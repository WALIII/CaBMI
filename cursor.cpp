/*
* cursor.cpp
*
*  Created on: Sep 19, 2017
*      Author: Nuria
*      Email: nvl@berkeley.edu
*
* A set of functions  to return a cursor value from the prairie system.
* Adapted from plexton BMI
*/

#include "cursor.h"

/*******************************
* Define class member functions
*******************************/
//constructor
CursorParams::CursorParams(void)
{
	//initialize state variables
	engage = false;
	params = false;
	cursorMutex = CreateMutex(
		NULL,              // default security attributes
		FALSE,             // initially not owned
		NULL);             // unnamed mutex)
}

//class functions
float CursorParams::get_cursor_val(void)
{
	float f;
	WaitForSingleObject((cursorMutex), INFINITE);
	__try {
		f = cursor_val;
	}
	__finally {
		ReleaseMutex((cursorMutex));
	}
	return f;
}
void CursorParams::set_cursor_val(float v)
{
	WaitForSingleObject((cursorMutex), INFINITE);
	__try {
		cursor_val = v;
	}
	__finally {
		ReleaseMutex((cursorMutex));
	}
}
int CursorParams::get_samp_int(void)
{
	return samp_int;
}
void CursorParams::set_samp_int(int i)
{
	samp_int = i;
}
int CursorParams::get_smooth_int(void)
{
	return smooth_int;
}
void CursorParams::set_smooth_int(int i)
{
	smooth_int = i;
}
vector<vector<long>> CursorParams::get_rois(void)
{
	return rois;
}
void CursorParams::set_rois(vector<vector<long>> v)
{
	rois = v;
}
int CursorParams::get_num_e1(void)
{
	return num_e1;
}
void CursorParams::set_num_e1(int i)
{
	num_e1 = i;
}
int CursorParams::get_num_e2(void)
{
	return num_e2;
}
void CursorParams::set_num_e2(int i)
{
	num_e2 = i;
}
bool CursorParams::is_engaged(void)
{
	return engage;
}
void CursorParams::set_engage(bool b)
{
	engage = b;
}
bool CursorParams::params_set(void)
{
	return params;
}
void CursorParams::params_var(bool b)
{
	params = b;
}
bool CursorParams::set_f0(void)
{
	f0 = obtainroidata(CursorParams::get_rois(), CursorParams::get_num_e1() + CursorParams::get_num_e2());
	if (f0[0] == 0)
	{
		return false;  // in case there is a problem with the reading of the data
	}
	else
	{
		return true;
	}
}
vector<short> CursorParams::get_f0()
{
	return f0;
}

/*******************************
* FUNCTIONS
*******************************/

extern "C" float get_cursor(vector<vector<long>>roivector, int num_e1, int num_e2, int interval, vector<short> f0)
/*a function to get the cursor value; taking into account the rois of the ensembles over a given
* time interval
*/
{
	int num_units = num_e1 + num_e2;
	float e1_value = 0, e2_value = 0;
	vector<short> roi_values(num_units, 0);
	float cursor_val = 0;
	//WINAPI types to store high-resolution time stamps
	LARGE_INTEGER StartingTime, EndingTime, ElapsedMilliseconds;
	LARGE_INTEGER Frequency;
	LONGLONG time_lost;
	//get the system processor time frequency value
	QueryPerformanceFrequency(&Frequency);

	//start the high resolution clock
	QueryPerformanceCounter(&StartingTime);
	// obtain values of rois
	roi_values = obtainroidata(roivector, num_units);
	//pause for the requested duration minus the time lost parsing the names
	//figure out how much time has elapsed
	QueryPerformanceCounter(&EndingTime);
	ElapsedMilliseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
	ElapsedMilliseconds.QuadPart *= 1000;
	ElapsedMilliseconds.QuadPart /= Frequency.QuadPart;
	time_lost = ElapsedMilliseconds.QuadPart;
	if (time_lost < interval)
	{
		Sleep(interval - time_lost);
	}
	for (int i = 0; i < num_units; i++)
	{
		if (i < num_e1)
		{
			e1_value += ((float)roi_values[i] - f0[i]) / f0[i] * 100;  // add values
		}
		else
		{
			e2_value += ((float)roi_values[i] - f0[i]) / f0[i] * 100;
		}
	}
	cursor_val = e1_value / num_e1 - e2_value / num_e2; // cursor value normalized by number of units
														// By diving by the number of units it allows to have unmatched number of cells for both ensembles
	cout << e1_value << " - ";
	return cursor_val;
}


DWORD WINAPI cursor_thread(LPVOID lpParam)
/*This function runs a thread in the background with get_cursor the whooole time
* it creates a buffer where to store the value of the cursor continuosly.
* The function is a revised version from the plexton BMI
*/
{
	/* initialize random seed: */
	//srand (time(NULL));
	//cast input parameters
	CursorParams* params = (CursorParams*)lpParam;
	float *buffer;
	float val;
	float smoothed_val;
	//create a buffer
	buffer = new float[params->get_smooth_int()];
	//fill with zeros
	for (int i = 0; i < params->get_smooth_int(); i++)
	{
		buffer[i] = 0;
	}
	while (params->is_engaged() == true)
	{
		val = get_cursor(params->get_rois(), params->get_num_e1(), params->get_num_e2(), params->get_samp_int(), params->get_f0());
		// if the data is not written fast enough in the buffer it can not be retrieved fully and the rrds
		// will return a 0, val will be 0 - 0 = 0 we should drop that value as is not a correct value
		if (val == 0)
		{
			continue;
		}
		advance_buffer(buffer, params->get_smooth_int(), val);
		smoothed_val = arr_mean(buffer, params->get_smooth_int());
		params->set_cursor_val(float(smoothed_val));
	}
	delete[] buffer;
	return NULL;
}


extern "C" void init_cursor(CursorParams *params)
/*This function creates a thread to run get cursor
* The function is a revised version from the plexton BMI
*/
{
	//start a thread to execute sound playback 
	//thread variables
	DWORD cursorId;
	HANDLE cursorThread;

	cursorThread = CreateThread(
		NULL, // default security attributes
		0, // use default stack size
		cursor_thread, // thread function
		params, // argument to thread function (global cursor struct)
		0, // use default creation flags
		&cursorId); // returns the thread identifier)

	if (cursorThread == NULL)
		printf("CreateThread() failed, error: %d.\n", GetLastError());
}


extern "C" void advance_buffer(float* buffer, int buff_len, float new_data)
/* a function to shift a buffer and append new data. Args are a pointer to the buffer,
*the length of the buffer, and the value of the new data to append.
*/
{
	//shift the buffer
	for (int i = 0; i < buff_len - 1; i++)
	{
		buffer[i] = buffer[i + 1];
	}
	//append the new data
	buffer[buff_len - 1] = new_data;
}


extern "C" float arr_mean(float* d, int length)
/* helper function to calculate the mean of a double array
* input vals are a pointer to the array, and the length of the array
*/
{
	//variable to store the sum
	float total = 0;
	//result var
	float result;
	for (int i = 0; i < length; i++)
	{
		total += float(d[i]);
	}
	result = total / length;
	return result;
}

