/*
* cursor.h
*
*  Created on: Sep 19, 2017
*      Author: Nuria
*      Email: nvl@berkeley.edu
*
* A set of functions  to return a cursor value from the prairie system.
* Adapted from plexton BMI
*/

#ifndef __CURSOR_H__
#define __CURSOR_H__
#include <windows.h>
#include <iostream>
#include <string>
#include <stdlib.h>
#include "prairie_utils.h"
#include <time.h>

class CursorParams {
public:
	//default constructor
	CursorParams(void);
	//functions to get and set parameters
	float get_cursor_val(void);
	void set_cursor_val(float v);
	int get_samp_int(void);
	void set_samp_int(int i);
	int get_smooth_int(void);
	void set_smooth_int(int i);
	vector<vector<long>> get_rois(void);
	void set_rois(vector<vector<long>>);
	int get_num_e1(void);
	void set_num_e1(int i);
	int get_num_e2(void);
	void set_num_e2(int i);
	bool is_engaged(void);
	void set_engage(bool b);
	bool params_set(void);
	void params_var(bool b);
	bool set_f0(void);
	vector<short> get_f0(void);
	HANDLE cursorMutex;
private:
	//cursor variables
	float cursor_val;
	int samp_int;
	int smooth_int;
	int num_e1;
	int num_e2;
	bool params;
	bool engage;
	vector<vector<long>> rois;
	vector<short> f0;
};

//function to return the value of the cursor 
extern "C" float get_cursor(vector<vector<long>>roivector, int num_e1, int num_e2, int interval, vector<short> f0);

DWORD WINAPI cursor_thread(LPVOID lpParam);

//function to start a cursor thread
extern "C" void init_cursor(CursorParams *params);

//Function to shift a buffer and append new data
extern "C" void advance_buffer(float* buffer, int buff_len, float new_data);

//Function that creates a thread to run get cursor
extern "C" float arr_mean(float* d, int length);

#endif