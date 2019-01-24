#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <ap_int.h>
#include <ap_fixed.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <hls_stream.h>
using namespace hls;
void kmeans_histo_s(hls::stream<ap_uint<4>> &image_in, hls::stream<ap_uint<4>> &image_out, ap_uint<4> histo[16]){
#pragma HLS INTERFACE s_axilite port=return name=CRTL_BUS
#pragma HLS INTERFACE bram port=histo
#pragma HLS INTERFACE axis register both port=image_out
#pragma HLS INTERFACE axis register both port=image_in

	ap_uint<10> i,j,m;
	ap_uint<8> Thresh[5];
	ap_uint<4> image_buffer[(640*480)];
	ap_uint<4> gray_ID=0;
	ap_uint<5> k[4];
	ap_uint<32> sum=0;
	ap_uint<32> numberOfCluster=0;		// the number of pixels in a certain cluster
	ap_uint<6> wcount=0;				// the times of iterations
	ap_uint<32> numberOfPix=0;
	ap_uint<32> tempTotal=0;	// numberOfPix is the number of pixels in a certain gray level
	bool histoDone;
	sum=0; numberOfCluster=0; wcount=0;	numberOfPix=0; tempTotal=0; gray_ID=0;
	histoDone=false;
	Thresh[0] = 0;
	Thresh[1] = 4;
	Thresh[2] = 5;
	Thresh[3] = 12;
	Thresh[4] = 16;
	for (i=0;i<16;i++){
#pragma HLS PIPELINE
		histo[i] = 0;
	}
	for (i=0;i<(640*480);i++){
#pragma HLS PIPELINE
		gray_ID = image_in.read();
		image_buffer[i] = gray_ID;
		histo[gray_ID]+=1;
	}
	for (wcount=0;wcount<2;wcount++){ //0times iterations
		for (i = 0; i<4; i++){
			sum = 0;					// initial the parameters
			numberOfCluster = 0;
			for (m=Thresh[i];m<Thresh[i+1];m++) {
	// go through the whole histogram
					//find which cluster the pixel should be in
					numberOfPix = histo[m];			// how many pixels in a cluster
					tempTotal = numberOfPix * m;	//	the total gray level in the same gray level
					sum = sum + tempTotal;				// add them together => the total gray level of a certain cluster
					numberOfCluster = numberOfCluster + numberOfPix;	// the total number of pixels in a certain cluster
			}
			if (numberOfCluster!= 0) {
					k[i] = (ap_uint<4>)(sum / numberOfCluster);
			}
			else {
					k[i] = 0;
			}
		 }
		Thresh[0] = 0;
		Thresh[1] = (k[0]+k[1])>>1;
		Thresh[2] = (k[1]+k[2])>>1;
		Thresh[3] = (k[2]+k[3])>>1;
		Thresh[4] = 16;
	}
	for (i=0;i<(640*480);i++){
		if ((image_buffer[i]>=Thresh[0])&&(image_buffer[i]<Thresh[1])){
			image_out.write = k[0];
		}
		else if ((image_buffer[i]>=Thresh[1])&&(image_buffer[i]<Thresh[2])){
			image_out.write = k[1];
		}
		else if ((image_buffer[i]>=Thresh[2])&&(image_buffer[i]<Thresh[3])){
			image_out.write = k[2];
		}
		else if ((image_buffer[i]>=Thresh[3])&&(image_buffer[i]<Thresh[4])){
			image_out.write = k[3];
		}
	}

}
