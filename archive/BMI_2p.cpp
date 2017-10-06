//============================================================================
// Name        : BMI_2p.cpp
// Author      : Nuria Vendrell Llopis (nvl@berkeley.edu)
// Version     : 1
// Copyright   : open-source
// Description : master functions to control BMI via Python based on BMI_FREQ from th Plexton BMI
//============================================================================

#include <Python.h>
#include <numpy/arrayobject.h>
#include "cursor.h"
#include "prairie_utils.h"
//#include "feedback.h"
//#include "reward.h"
#include <string>
#include <stdlib.h>

//initialize a FeedbackParams object to control sound output
//FeedbackParams feedback_params;
//initialize a CursorParams object
CursorParams cursor_params;

// flag to be sure that the rois have been passed
bool flag_rp = false;


static PyObject * connect_2p(PyObject* self, PyObject* args)
/* Function to open connection to 2p */
{
	// commands to connect with the 2p API
	bool cc=false;
	try
	{
		initialize_prairie();
		connect_prairie();
		cc = check_connection();
	}
	catch (runtime_error &e)
	{
		cout << "Caught a runtime_error exception: " << e.what()
			<< "\n If this keeps happening reinitiate the Prairie"
			<< "\n attempting to disconnect..." << endl;
		disconnect_prairie();
	}
	if (cc)
	{
		PyGILState_STATE state1 = PyGILState_Ensure();
		PySys_WriteStdout("Client connected.\n");
		PyGILState_Release(state1);
	}
	else
	{
		PyGILState_STATE state1 = PyGILState_Ensure();
		PySys_WriteStdout("Client connection failed; Have you started Prairie View!\n");
		PyGILState_Release(state1);
	}
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None); 
	PyGILState_Release(state);
	return Py_None;
}


static PyObject * disconnect_2p(PyObject* self, PyObject* args)
/* Function to stop connection to 2p */
{
	disconnect_prairie();
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

// TODO function to deal with events. Where are we goint to store them?


static PyObject * set_cursor_params(PyObject* self, PyObject* args)
/* Function to set cursor parameters*/
{
	PyObject * arg1 = NULL, * arrayobject = NULL; 
	int num_e1, num_e2, samp_int, smooth_int;
	bool readingok = false;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "iiiiO", &num_e1, &num_e2, &samp_int, &smooth_int, &arg1))
		return NULL;
	//set parameters
	npy_intp *  dims = PyArray_DIMS(args1);
	cursor_params.set_num_e1(num_e1);
	cursor_params.set_num_e2(num_e2);
	cursor_params.set_samp_int(samp_int);
	cursor_params.set_smooth_int(smooth_int);
	readingok = cursor_params.set_f0();
	//TODO set_f0 should be done with the data from baseline so posibly passed from python
	if (!readingok)
	{
		cout << "There is a problem with the recoding!! \n Can't obtain baseline F0, cant continue " << endl;
		return NULL;  // it will not start the cursor since params_var is not true
	}
	// only if readingok is TRUE it will update params_var --> no start cursor
	if (flag_rp) //if the rois have been passed
	{
		cursor_params.params_var(true);
	}
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

void passrois(PyObject *list)
{
	int i, n_arrays;

	// Get the number of elements in the list
	n_arrays = PyObject_Length(list);
	vector<vector<long>> rois(n_arrays);

	for (i = 0; i < n_arrays; i++)
	{
		PyObject *elem;
		elem = PyList_GetItem(list, i);
		int arraysize = PyArray_SIZE(elem);
		long * pd = static_cast<long*>PyArray_DATA(elem);
		rois[i].assign(pd, pd + arraysize);
	}
	flag_rp = true;
	cursor_params.set_rois(rois);
}


static PyObject * start_cursor(PyObject* self, PyObject* args)
/* Function to start the cursor*/
{
	if (cursor_params.params_set() == false)
	{
		PyGILState_STATE state1 = PyGILState_Ensure();
		PySys_WriteStdout("Set parameters first!.\n");
		PyGILState_Release(state1);
	}
	else
	{
		cursor_params.set_engage(true);
		init_cursor(&cursor_params);
	}
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * stop_cursor(PyObject* self, PyObject* args)
/* Function to stop the cursor*/
{	
	if (cursor_params.is_engaged() == false)
	{
		PyGILState_STATE state1 = PyGILState_Ensure();
		PySys_WriteStdout("Already stopped.\n");
		PyGILState_Release(state1);
	}
	else
	{
		cursor_params.set_engage(false);
	}
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * get_cursor_val(PyObject* self, PyObject* args)
/* Returns the cursor Value*/
{
	if (cursor_params.is_engaged() == true)
	{
		return Py_BuildValue("f", cursor_params.get_cursor_val());
	}
	else
	{
		return Py_BuildValue("f", 0.0);
	}
}

/*
static PyObject * set_feedback(PyObject* self, PyObject* args)
/* Function to change the frequency of the audio feedback 

{
	float val;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "f", &val))
		return NULL;
	feedback_params.set_new_freq(val);
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * start_feedback(PyObject* self, PyObject* args)
/* Function to start audio feedback playback	
{
	float midpoint;
	int interval;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "fi", &midpoint, &interval))
		return NULL;
	//initialize parameter values
	feedback_params.set_midpoint(midpoint);
	feedback_params.set_current_freq(midpoint);
	feedback_params.set_new_freq(midpoint);
	feedback_params.set_interval(interval);
	feedback_params.set_trigger(true);
	//start the feedback thread
	init_feedback(&feedback_params);
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * stop_feedback(PyObject* self, PyObject* args)
/* Function to stop audio playback (actually sets freq to inaudible; doesn't actually stop) 

{
	feedback_params.set_current_freq(0);
	feedback_params.set_new_freq(0);
	//return nothing
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * resume_feedback(PyObject* self, PyObject* args)
/* Resume audio playback to a given freq 
{
	float val;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "f", &val))
		return NULL;
	feedback_params.set_new_freq(val);
	feedback_params.set_current_freq(val);
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * play_noise(PyObject* self, PyObject* args)
/* Play a noise burst 
{
	noise_burst();
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * trig_nidaq(PyObject* self, PyObject* args)
/* Send a TTL pulse to the behavior box 
// TODO check how this works with each behaviour box
{
	int devNum;
	int portNum;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "ii", &devNum, &portNum))
		return NULL;
	//pass args to the function
	trigger_abet(devNum, portNum);
	PyGILState_STATE state = PyGILState_Ensure();
	Py_INCREF(Py_None);
	PyGILState_Release(state);
	return Py_None;
}

static PyObject * read_nidaq(PyObject* self, PyObject* args)
/* Read the status of a NIDAQ DIO port 
// TODO check how this works with each behaviour box
{
	int devNum;
	int portNum;
	int result;
	//parse arguments from python
	 if (!PyArg_ParseTuple(args, "ii", &devNum, &portNum))
		return NULL;
	//pass args to the function
	result = read_abet(devNum, portNum);
	return Py_BuildValue("i", result);
}
*/

//Utils:
static PyMethodDef BMI2pmethods[] = {
	{"connect_client", connect_2p, METH_VARARGS,
		"Opens a connection with the prairielink"},
	{"disconnect_client", disconnect_2p, METH_VARARGS,
		"Closes the connection to prairie"},
	{"set_cursor_params", set_cursor_params, METH_VARARGS,
		"Set the parameters for calculating cursor values"},
	{"start_cursor", start_cursor, METH_VARARGS,
		"Initialize the thread to begin calculating cursor values"},
	{"stop_cursor", stop_cursor, METH_VARARGS,
		"Kill an active cursor thread"},
	{"get_cursor_val", get_cursor_val, METH_VARARGS,
		"Returns the current cursor value"},
	/*{"set_feedback", set_feedback, METH_VARARGS,
		"Change the feedback frequency value"},
	{"start_feedback", start_feedback, METH_VARARGS,
		"Start the audio feedback"},
	{"stop_feedback", stop_feedback, METH_VARARGS,
		"Shut down the audio playback"},
	{"resume_feedback", resume_feedback, METH_VARARGS,
		"Resumes the audio playback"},
	{"play_noise", play_noise, METH_VARARGS,
		"Play a white noise burst"},
	//{"send_event", send_event, METH_VARARGS,
	//	"Sends a user event on a given channel"},
	{"trig_nidaq", trig_nidaq, METH_VARARGS,
	 	"Briefly pulses the DI/O on the nidaq"},
	{"read_nidaq", read_nidaq, METH_VARARGS,
	 	"Reads a DIO sample from a nidaq port"},*/
	{NULL, NULL, 0, NULL} //sentinal
};

static struct PyModuleDef BMI2pmodule = {
    PyModuleDef_HEAD_INIT,
    "BMI_2p",   /* name of module */
    NULL, /* module documentation, may be NULL */
    -1,       /* size of per-interpreter state of the module,
                 or -1 if the module keeps state in global variables. */
	BMI2pmethods
};

PyMODINIT_FUNC PyInit_BMI_2p(void)
{
	return PyModule_Create(&BMI2pmodule);
}