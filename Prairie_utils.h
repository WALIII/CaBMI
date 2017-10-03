/*
* prairie_utils.h
*
*  Created on: Sep 14, 2017
*      Author: Nuria
*      Email: nvl@berkeley.edu
*
* This set of functions are utilities to interfacing with the prairie system.
*/


#ifndef __PRAIRIE_UTILS_H__
#define __PRAIRIE_UTILS_H__

#ifdef _DEBUG
# pragma comment(lib, "comsuppwd.lib")
#else
# pragma comment(lib, "comsuppw.lib")
#endif
# pragma comment(lib, "wbemuuid.lib")

#include <ObjBase.h>
#include <windows.h>
#include <atlbase.h>
//#include <atlcomcli.h>
#include <stdio.h>
#include <exception>
#include <iostream>
#include <string>
#include <chrono>
#include <vector>
#include <time.h>
#include <comutil.h>
#include <sstream>
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui.hpp>

//using namespace cv;
using namespace std;


struct collect_info
{
	int ppl, lpf, spp;
};

// Function to obtain info about the recording of the 2p
collect_info twop_info();

// Function to instantiate prairie API
extern "C" void initialize_prairie();

// Function to release prairie API
extern "C" void uninit();

// Function to use prairie METHOD "Connect"
extern "C" bool connect_prairie();

extern "C" int pixelsperline();

// Function to use prairie METHOD "Disconnect"
extern "C" void disconnect_prairie();

// Function to use prairie METHOD "Connected"
extern "C" bool check_connection();

//Function to use prairie METHOD ReadRawDataStream
vector<int> getbufferdata();

//Function to returns only the value of the cells define in roivector.
vector<short> obtainroidata(vector<vector<long>>roivector, int num_units);

//Function to send commands to prairie
extern "C" bool SendScriptCommands(BSTR);

//Debug function to show data.
//void showdata();

#endif