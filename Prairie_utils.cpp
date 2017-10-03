/*
* prairie_utils.cpp
*
*  Created on: Aug 28, 2017
*      Author: Nuria
*      Email: nvl@berkeley.edu
*
* This set of functions are utilities to interfacing with the prairie system.
*/

#include "Prairie_utils.h"

/*******************************
* INITIALIZE VARIABLES
*******************************/

/* Initializes the smart pointer pl to connect to prairie.
* This pointer is the one and only connection instance to the prairie_link application
* Creates a smart pointer with interface IDispatch
* I choose IDispatch, because we don't have access to the DLL from Prairie
* One could use the interface name to create CCopPtr to that interface but we don't know them
* One can check the interfaces in OLE/COM object viewer but the name of the interfaces does not work
* So basically, this is the only solution to access the methods of prairielink.application	for c++
* This should be easier to do with c#, vb or any other with .net framework
*/

CComPtr<IDispatch> pl;

/* Gets the dispids of the methods we need.
* When "initialize prairie" this DISPIDs are given the id's of each method
*/

DISPID dispidConnect;
DISPID dispidConnected;
DISPID dispidDisconnect;
DISPID dispidPixelsPerLine;
DISPID dispidLinesPerFrame;
DISPID dispidGetImage;
DISPID dispidGetImage_2;
DISPID dispidDroppedData;
DISPID dispidReadRawDataStream;
DISPID dispidSamplesPerPixel;
DISPID dispidSSC;

// initialize empty parameters for methods
DISPPARAMS dispparamsNoArgs = { NULL, NULL, 0, 0 };
EXCEPINFO ExcepInfo;


/*******************************
* FUNCTIONS
*******************************/

extern "C" void initialize_prairie()
/* Function to instantiate prairie API
*  Must be called at the beginning and before any method can be used
*  It creates an instance of the application and initializes the dispids of each method
*/
{
	// initialize HRESULTs this helps a lot with debugging but has no other effect in the code
	HRESULT hr;

	// Methods from the Prairie_link that will obtain the dispid. Based on Prairie Documentation.
	// Information about this methods can be found in Prairie_view "help"
	LPOLESTR pszMethodC = OLESTR("Connect");
	LPOLESTR pszMethodCd = OLESTR("Connected");
	LPOLESTR pszMethodD = OLESTR("Disconnect");
	LPOLESTR pszMethodPPL = OLESTR("PixelsPerLine");
	LPOLESTR pszMethodLPF = OLESTR("LinesPerFrame");
	LPOLESTR pszMethodDD = OLESTR("DroppedData");
	LPOLESTR pszMethodRRDS = OLESTR("ReadRawDataStream");
	LPOLESTR pszMethodSPP = OLESTR("SamplesPerPixel");
	LPOLESTR pszMethodGI = OLESTR("GetImage");
	LPOLESTR pszMethodGI2 = OLESTR("GetImage_2");
	LPOLESTR pszMethodSCC = OLESTR("SendScriptCommands");

	//Not yet implemented 
	//LPOLESTR pszMethodSSC = OLESTR("SendScriptCommands");
	//LPOLESTR pszMethodGS = OLESTR("GetState");
	//LPOLESTR pszMethodGMP = OLESTR("GetMotorPosition");

	// initialize the COM
	// finds the correct ID of the application 
	CLSID clsid;
	HRESULT hrid = CLSIDFromProgID(L"PrairieLink.Application", &clsid);
	if (FAILED(hrid))
	{
		throw runtime_error("Initialize failed");
		return;
	}
	// Creates an instance of the application with the previous ID
	pl.CoCreateInstance(clsid, NULL, CLSCTX_ALL);

	// Initialize the dispid for each of the methods of prairie_link
	// We get them all here but the dispids are set as globals so can be used in any of the subroutines
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodC, 1, LOCALE_SYSTEM_DEFAULT, &dispidConnect);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodCd, 1, LOCALE_SYSTEM_DEFAULT, &dispidConnected);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodD, 1, LOCALE_SYSTEM_DEFAULT, &dispidDisconnect);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodPPL, 1, LOCALE_SYSTEM_DEFAULT, &dispidPixelsPerLine);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodLPF, 1, LOCALE_SYSTEM_DEFAULT, &dispidLinesPerFrame);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodGI, 1, LOCALE_SYSTEM_DEFAULT, &dispidGetImage);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodGI2, 1, LOCALE_SYSTEM_DEFAULT, &dispidGetImage_2);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodDD, 1, LOCALE_SYSTEM_DEFAULT, &dispidDroppedData);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodRRDS, 1, LOCALE_SYSTEM_DEFAULT, &dispidReadRawDataStream);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodSPP, 1, LOCALE_SYSTEM_DEFAULT, &dispidSamplesPerPixel);
	hr = pl->GetIDsOfNames(IID_NULL, &pszMethodSCC, 1, LOCALE_SYSTEM_DEFAULT, &dispidSSC);
}

extern "C" void uninit()
/* Function to release prairie API*/
{
	CoUninitialize();
}

extern "C" bool connect_prairie()
/* Function to use prairie METHOD "Connect"
* It connects to the prairie application once it has been instantiated (by initialize_prairie)
* ONLY if in the same computer (see prairie_link methods for remote access)
* Remote access not implemented!
* This function connects to the currently running instance of Prairie View.
* Returns true if the connection was successful or false if the connection failed.
*/
{
	HRESULT hr;
	VARIANT *VarResultC;
	bool cc_out;
	VarResultC = new VARIANT;
	VariantInit(VarResultC);
	cout << "Connecting..." ;
	hr = pl->Invoke(dispidConnect, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, VarResultC, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("Connect method failed");
		return false;
	}
	else
	{
		cout << "Connected to Prairie_link: " << endl;
	}
	cc_out = (*VarResultC).boolVal;
	VariantClear(VarResultC);
	Sleep(1000);
	return cc_out;
}

extern "C" void disconnect_prairie()
/* Function to use prairie METHOD "Disconnect"
* This method disconnects from Prairie View.
* Prairie View needs to do a little bit of cleanup when a communication channel isn’t being used anymore,
*  so failure to disconnect, particularly after numerous connections are made in the same session,
*  could result in undesirable behavior.
* After disconnection one needs to connect again but not to initialize again to access methods from that API.
*
*/
{
	HRESULT hr;
	hr = pl->Invoke(dispidDisconnect, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, NULL, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("Disconnect method failed");
		return;
	}
	else
	{
		cout << "Disconnected succesfully" << endl;
	}
}

extern "C" bool check_connection()
/* Function to use prairie METHOD "Connected"
* This function returns true if a connection has been made or false if no connection is present.
* VarResultCd.boolVal returns -1 when True... no idea why
*/
{
	HRESULT hr;
	VARIANT *VarResultCd;
	bool cc_out;
	VarResultCd = new VARIANT;
	VariantInit(VarResultCd);
	hr = pl->Invoke(dispidConnected, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, VarResultCd, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("Connected method failed");
		return FALSE;
	}
	//TODO check if the VarResultCd.boolVal actually works (in debug returns 0 for False and -1 for True... which is weird
	cc_out = (*VarResultCd).boolVal;
	VariantClear(VarResultCd);
	return cc_out;
}

int pixelsperline()
/* Function to use prairie METHOD PixelsPerLine
* This function returns the number of image pixels in the width/X dimension as an integer.
*/
{
	HRESULT hr;
	VARIANT *VarResultPPL;
	int ppl_out;
	VarResultPPL = new VARIANT;
	VariantInit(VarResultPPL);

	hr = pl->Invoke(dispidPixelsPerLine, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, VarResultPPL, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("PixelsPerLine method failed");
		return 0;
	}
	//TODO: check if VarResultPPL.intval works.
	ppl_out = (*VarResultPPL).intVal;
	VariantClear(VarResultPPL);
	return ppl_out;
}

int linesperframe()
/* Function to use prairie METHOD LinesPerFrame
* This function returns the number of image pixels in the height/Y dimension as an integer.
*/
{
	HRESULT hr;
	VARIANT *VarResultLPF;
	int lpf_out;
	VarResultLPF = new VARIANT;
	VariantInit(VarResultLPF);

	hr = pl->Invoke(dispidLinesPerFrame, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, VarResultLPF, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("LinesPerFrame method failed");
		return 0;
	}
	//TODO: check if VarResultLPF.intval works.
	lpf_out = (*VarResultLPF).intVal;
	VariantClear(VarResultLPF);
	return lpf_out;
}

int samplesperpixel()
/* Function to use prairie METHOD SamplesPerPixel
* This function returns how many samples are acquired for each pixel in the image. This is mainly useful
* when used in conjunction with the ReadRawDataStream function to figure out how to parse the raw data stream.
*/
{
	HRESULT hr;
	VARIANT *VarResultSPP;
	int spp_out;
	VarResultSPP = new VARIANT;
	VariantInit(VarResultSPP);

	hr = pl->Invoke(dispidSamplesPerPixel, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, VarResultSPP, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("SamplesPerPixel method failed");
		return 0;
	}
	//TODO: check if VarResultLPF.intval works.
	spp_out = (*VarResultSPP).intVal;
	VariantClear(VarResultSPP);
	return spp_out;
}

extern "C" bool SendScriptCommands(BSTR scriptcomand)
/*Function to use prairie METHOD SendScriptCommands
* This function sends a string of script commands to Prairie View which will then be run.
* If the script commands run successfully the function will return true, otherwise it will return false.
* For a complete listing of available script commands please reference the script command documentation
* accessible from the script editor under the Tools menu in Prairie View, or use this link.
* Some script commands can return values; each time a script command returns a value an event will
* be raised for which a handler can be registered to do something with the value.
* There are also specific functions to call a single script command which returns a value without
* using events.  See the event handling section below for more details.
*/ 
{
	HRESULT hr;
	VARIANT *VarResultSSC;
	VARIANT paramsRRDS[1];
	DISPPARAMS dispparamsSSC;
	bool cc_out;
	VarResultSSC = new VARIANT;
	VariantInit(VarResultSSC);


	paramsRRDS[0].vt = VT_BSTR;
	paramsRRDS[0].bstrVal = SysAllocString(scriptcomand);  // need to check Why do I need to pass parameters for this to work
	dispparamsSSC.cArgs = 1;
	dispparamsSSC.cNamedArgs = 0;
	dispparamsSSC.rgvarg = paramsRRDS;

	
	hr = pl->Invoke(dispidSSC, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsSSC, VarResultSSC, &ExcepInfo, NULL);
	if (FAILED(hr))
	{
		throw runtime_error("Script commands method failed");
		return FALSE;
	}
	//TODO check if the VarResultCd.boolVal actually works (in debug returns 0 for False and -1 for True... which is weird
	cc_out = (*VarResultSSC).boolVal;
	VariantClear(VarResultSSC);
	return cc_out;
}


collect_info twop_info()
/* Function to obtain recording parameters to compute pixel position on buffer
* This function returns an array with PPL, LPF and SPP
*/
{
	collect_info ti;
	ti.ppl = pixelsperline();
	ti.lpf = linesperframe();
	ti.spp = samplesperpixel();

	return ti;
}

vector<int> getbufferdata()
/* Function to use prairie METHOD ReadRawDataStream
* In order to use this function raw data streaming needs to be enabled by calling the script command ‘–srd true’,
*  otherwise this function will never return any samples.
* This function will return an array of samples as they are read off of the acquisition card.
* This function will guarantee that the chunks of data returned will form contiguous whole frames.
* If frames of data are not read off fast enough, only the most recent frames will be kept and the stream will omit
*  the frame(s) in between (unless the buffer frames parameter passed to the –srd command is non­zero which will return
*  all data and stop streaming if the data is not read out fast enough to keep up). Making sense of the data stream
*  requires knowledge of the acquisition being run, like how many pixels are in a line, how many lines are
*  in a frame, how many samples are acquired for each pixel, and how many channels of data are being acquired.
* All of these things can be polled for using script commands. For example a galvo mode acquisition for two channels at a 4us
*  dwell time will have two 16­bit values for each sample (one for each channel) and 10 samples for each pixel (4/.4).
* The SamplesPerPixel function can help figure this out for other acquisition modes.
* Multiple channels for a camera based acquisition will not be interleaved.
* Using this function will definitely require some trial and error as every application will be different.
*/
{
	//short pshort[1000];
	//auto ap = addressof(pshort[0]);
	collect_info ti = twop_info();
	const long buffersize = ti.ppl * ti.lpf * ti.spp;
	//const long buffersize = 4194303;
	vector<int> rrds_out(buffersize, 22); //initialize vector all to value 22 (stupid value to see if rrd overwrites)
	int *pVals = &rrds_out[0];
	ostringstream commandline;
	string programid = "Project1.exe ";
	commandline << "-rrd " << programid << (int*)pVals << " " << to_string(buffersize);
	cout << commandline.str() << endl;
	_bstr_t auxbstr(commandline.str().c_str());
	bool ssc_out = SendScriptCommands(auxbstr);
	cout << "pointer value: " << *pVals << endl;
	cout << "first position vector value: " <<rrds_out[0] << endl;

	//bool lv = SendScriptCommands(L"-rrd");
	/*HRESULT hr;
	VARIANT paramsRRDS[1];
	VARIANT *VarResultRRDS;
	DISPPARAMS dispparamsRRDS;
	VarResultRRDS = new VARIANT;
	VariantInit(VarResultRRDS);
	
	paramsRRDS[0].vt = VT_I2;
	paramsRRDS[0].intVal = 0;  // need to check Why do I need to pass parameters for this to work
	dispparamsRRDS.cArgs = 1;
	dispparamsRRDS.cNamedArgs = 0;
	dispparamsRRDS.rgvarg = paramsRRDS;

	//retrieves the whole buffer;	
	hr = pl->Invoke(dispidReadRawDataStream, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsRRDS, VarResultRRDS, &ExcepInfo, NULL);


	if (FAILED(hr))
	{
		throw runtime_error("ReadRawDataStream failed");
	}
	SAFEARRAY* pSafeArray = (*VarResultRRDS).parray;
	long lBound, uBound;
	SafeArrayGetLBound(pSafeArray, 1, &lBound);
	SafeArrayGetUBound(pSafeArray, 1, &uBound);
	LONG count = uBound - lBound + 1;
	short * pVals;
	SafeArrayAccessData(pSafeArray, (void**)&pVals);
	VariantClear(VarResultRRDS);
	vector<short> rrds_out (pVals, pVals + count);
	*/
	//
	return rrds_out;
}

vector<short> obtainroidata(vector<vector<long>>roivector, int num_units)
/* This is basically the same as getbufferdata but instead of returning the whole buffer as variant
* returns only the value of the cells define in roivector.
* roivector is a vector of units in which each component is the pixel belonging to each unit
*/
{
	VARIANT paramsRRDS[1];
	VARIANT *bufferdata;
	DISPPARAMS dispparamsRRDS;
	vector<short> roi_values(num_units, 2);
	bufferdata = new VARIANT;
	VariantInit(bufferdata);

	// initialize the communication con prairie to obtain buffer
	paramsRRDS[0].vt = VT_I2;
	paramsRRDS[0].intVal = 1;  // TODO need to check Why do I need to pass parameters for this to work
	dispparamsRRDS.cArgs = 1;
	dispparamsRRDS.cNamedArgs = 0;
	dispparamsRRDS.rgvarg = paramsRRDS;

	// obtains buffer of data
	pl->Invoke(dispidReadRawDataStream, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsRRDS, bufferdata, &ExcepInfo, NULL);
	// defines a vector which will be used to read from the data
	SAFEARRAY* pSafeArray = (*bufferdata).parray;
	int * pVals;
	SafeArrayAccessData(pSafeArray, (void**)&pVals);
	cout << "debug 6: pointer first value:   " << pVals[0] << endl;
	for (int i = 0; i < num_units; i++)  // for each roi
	{
		int px = 0, cellvalue = 0, npixel = 0; // initialize values
		for (long indexroi : roivector[i])  // for each element of the roi
		{
			cellvalue += pVals[indexroi];
			npixel += 1;
			cout << "debug 7: actual neuron value: " << cellvalue << endl;
		}
		roi_values[i] = cellvalue / npixel;
	}
	SafeArrayUnaccessData(pSafeArray);
	VariantClear(bufferdata);
	return roi_values;
}

/*
void showdata()
/*This function is basically a debug function to see if it read correctly from the buffer
* it will show an image based on the data retrieved by the buffer
{
	VARIANT rrds;
	Sleep(100);
	rrds = getbufferdata(); // get data
	collect_info ti;
	ti = twop_info();  //get variables of recording

	short * pVals;
	HRESULT hr = SafeArrayAccessData(rrds.parray, (void**)&pVals);
	vector<short> v(ti.lpf*ti.ppl);
	vector<short> vall(pVals, pVals + ti.lpf*ti.ppl*ti.spp);

	if (ti.spp == 1)
	{
		v = vall;
	}
	else
	{
		for (int i = 0; i < ti.lpf*ti.ppl; i++)
		{
			v[i] = vall[i*ti.spp];
		}
	}

	Mat kk;
	kk.create(ti.lpf, ti.ppl, CV_16S);
	memcpy(kk.data, v.data(), v.size() * sizeof(short));
	if (kk.data == NULL)
	{
		cout << "No image found! Check path." << endl;
	}
	namedWindow("Display window", WINDOW_NORMAL);
	resizeWindow("Display window", 600, 600);
	imshow("Display window", kk);

	waitKey(0);
}*/
