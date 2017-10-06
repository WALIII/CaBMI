/*
* silly main function to test shit
*
*  Created on: Aug 28, 2017
*      Author: Nuria
*      Email: nvl@berkeley.edu
*
* This set of functions are utilities to interfacing with the prairie system.
*/


#include "Prairie_utils.h"
#include "cursor.h"

using namespace std;
// initialize cursor params
CursorParams cursor_params;


void set_cursor_params()
{
	bool readingok;
	vector<vector<long>> r2(4, vector<long>(100, 50));
	r2[2] = vector<long>(100, 10);
	r2[3] = vector<long>(100, 2);
	
	cursor_params.set_samp_int(0); //TODO check this out sleeping time between recordings
	cursor_params.set_smooth_int(20); // average across 20
	cursor_params.set_rois(r2);   //to debug: needs to be implemented to obtain value
	cursor_params.set_num_e1(2);   //to debug: needs to be implemented to obtain value
	cursor_params.set_num_e2(2);   //to debug: needs to be implemented to obtain value
	readingok = cursor_params.set_f0();
	if (!readingok)
	{
		cout << "There is a problem with the recoding!! \n Can't obtain baseline F0, cant continue " << endl;
		return;  // it will not start the cursor since params_var is not true
	}
	cursor_params.params_var(true);
}

void start_cursor()
{	
	//check to see if the parameters have been set
	if (cursor_params.params_set() == false)
	{
		cout << "debug start cursor " << endl;
	}
	else
	{
		cursor_params.set_engage(true);
		init_cursor(&cursor_params);
	}
	
}

void stop_cursor()
{
	if (cursor_params.is_engaged() == false)
	{
		cout << "debug stop cursor " << endl;
	}
	else
	{
		cursor_params.set_engage(false);
	}
}

float get_cursor_val()
{
	if (cursor_params.is_engaged() == false)
	{
		cout << "debug get cursor val " << endl;
		return 0;
	}
	else
	{
		return cursor_params.get_cursor_val();
	}
}

void stupid() 
{

	
	//collect_info ti = twop_info();
	const long buffersize = 65536;
	//short *pVals = new short[buffersize];
	vector<short> rrds_out(buffersize);
	short *pVals = &rrds_out[0];
	//long buffersize = ti.ppl * ti.lpf * ti.spp * 16;
	ostringstream commandline;
	string programid = "Project1.exe ";
	commandline << "-rrd " << programid << " " << (short*)pVals << " " << to_string(buffersize);
	cout << commandline.str().c_str();
	cout << "end" << endl;
}


/*Basic functioning*/

int main()
{
	CoInitialize(NULL);
	if (true)
	{
		bool cc = FALSE;
		int num_units = 4;
		vector<short> roi_values(num_units, 2);
		collect_info ti;


		try
		{
			initialize_prairie();
			cc = connect_prairie();
			bool srd = SendScriptCommands(L"-srd true");
			bool lbs = SendScriptCommands(L"-lbs true 5");
			bool lv = SendScriptCommands(L"-lv");
			Sleep(3000);
			ti = twop_info();
		}
		catch (...)
		{
			cout << "Caught a runtime_error exception: " //<< e.what()
				<< "\n If this keeps happening reinitiate the Prairie"
				<< "\n attempting to disconnect..." << endl;
			disconnect_prairie();
			return 0;  // Return 0 means failed
		}

		if (!cc)  // If not connected to the Prairie but not error in connecting
		{
			cout << "You need to start Prairie link before launching the BMI program \n"
				<< " Please refer to the \"how to\"" << endl;
			return 0;  // Return 0 means failed
		}

		//set_cursor_params();
		//start_cursor();
		//Sleep(500); 
		//float gcv = get_cursor_val();
		//stop_cursor();

		//showdata();

		//vector<int>  rrds1 = getbufferdata();
		//Sleep(6);
		//vector<int>  rrds2 = getbufferdata();

		//cout << rrds1[0] << endl;

		vector<vector<long>> r2(4, vector<long>(10, 50));
		//auto t0 = std::chrono::high_resolution_clock::now();

		roi_values = obtainroidata(r2, num_units);

		//Sleep(5);
		//cout << "new chek" << endl;
		//roi_values = obtainroidata(r2, num_units);
		//auto t1 = std::chrono::high_resolution_clock::now();
		//auto dt = 1.e-9*std::chrono::duration_cast<std::chrono::nanoseconds>(t1 - t0).count();

		bool ssc = SendScriptCommands(L"-lv off");
		bool srdbye = SendScriptCommands(L"-srd false");
		disconnect_prairie();
	}
	CoUninitialize();
	return 1; // 1 means yaaaaaaay success wohoooo
	
}


//DISPPARAMS dispparams;
//VARIANT params[1];
//params[0].vt = VT_BOOL;
//params[0].boolVal = FALSE;
//dispparams.cArgs = 1;
//dispparams.cNamedArgs = 0;
//dispparams.rgvarg = params;

/*
VARIANT params[1], paramsRRDS[1];

params[0].vt = VT_I4;
params[0].intVal = 1;  //Channel 1
dispparams.cArgs = 1;
dispparams.cNamedArgs = 0;
dispparams.rgvarg = params;

paramsRRDS[0].vt = VT_I4;
paramsRRDS[0].intVal = 0;
dispparamsRRDS.cArgs = 1;
dispparamsRRDS.cNamedArgs = 0;
dispparamsRRDS.rgvarg = paramsRRDS;

hr = pl->Invoke(dispidConnected, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, &VarResultConnected, &ExcepInfo, NULL);
hr = pl->Invoke(dispidConnect, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, NULL, NULL, NULL);
hr = pl->Invoke(dispidPixelsPerLine, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, &VarResultPPL, &ExcepInfo, NULL);
hr = pl->Invoke(dispidGetImage, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparams, &VarResultGI, &ExcepInfo, NULL);
hr = pl->Invoke(dispidConnected, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, &VarResultConnected, &ExcepInfo, NULL);
hr = pl->Invoke(dispidReadRawDataStream, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsRRDS, &VarResultRRDS, &ExcepInfo, NULL);
//hr = pl->Invoke(dispidDisconnect, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, NULL, NULL, NULL);
//hr = pl->Invoke(dispidConnected, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dispparamsNoArgs, &pVarResult, NULL, NULL);
/////hr = pl.GetIDOfName(L"PrairieLink.application", &dispidConnect);
/////HRESULT hr = pl->GetIDsOfNames();

if (VarResultConnected.boolVal)
{
printf("yeah");
}
else
{
printf("Buuuuh");
}
printf("bushit");


	vector<vector <long > > roivector = {
		{ 1,2,3 },
		{ 4,5 },
		{ 6,7,8,9,0 },
		{ 4,7,8,9,10 }
	};

	//ppl = pixelsperline();
	//lpf = linesperframe();
	//spp = samplesperpixel();

		auto t0 = std::chrono::high_resolution_clock::now();
		rrds = getbufferdata(); // this is super slooooow
		auto t1 = std::chrono::high_resolution_clock::now();
		auto dt = 1.e-9*std::chrono::duration_cast<std::chrono::nanoseconds>(t1 - t0).count();


*/







//GENERAL TODO stuff:
//Prairie exception
//Getimage and getimage2



