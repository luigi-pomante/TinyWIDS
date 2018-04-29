

#include "Wids.h"
#include "TKN154.h"

#ifndef WIDS_SECURITY
#define WIDS_SECURITY
#endif

configuration IntrusionDetectionSystemC {

	provides {
		interface Init;
		interface AlarmGeneration;
		interface ThreatDetection;
		interface SystemInfo;
		interface NetworkUtility;

		interface RadioRx;
		interface RadioTx;

		interface SlottedCsmaCa;
		interface UnslottedCsmaCa;
	}

	uses {
		interface RadioRx as RRx;
		interface RadioTx as RTx;

		interface SlottedCsmaCa as SCsmaCa;
		interface UnslottedCsmaCa as UCsmaCa;

		interface Alarm<TSymbolIEEE802154,uint32_t> as GTSAlarm;
		interface IEEE154Frame;
		
		interface Notify<wids_attack_t> as RemoteDetection;
	}

} implementation {

	components TKNThreatDetectionP as TD;

	ThreatDetection = TD;
	SystemInfo = TD;

	components NetworkAdapterP;
	NetworkUtility = NetworkAdapterP;

	RemoteDetection = RD.RemoteInput;

	RadioRx = TD.RX;
	RadioTx = TD.TX;
	SlottedCsmaCa = TD.SCsma;
	UnslottedCsmaCa = TD.UnCsma;

	RTx = TD.RadioTx;
	SCsmaCa = TD.SlottedCsmaCa;
	UCsmaCa = TD.UnslottedCsmaCa;
	RRx = TD.RadioRx;

	// CCA = TD.CCA;
	IEEE154Frame = TD.IEEE154Frame;

	GTSAlarm = TD.Alarm;

	components new HashMapC(uint16_t, uint16_t, 10), new ModHashP(10);
	HashMapC.Hash -> ModHashP;

	TD.SEQNO -> HashMapC;

	components RF230DriverLayerP;
	TD.RadioFail -> RF230DriverLayerP;
	TD.RadioCCA -> RF230DriverLayerP;


	components WIDSC, NetworkAdapterP as NA, RemoteDetectionP as RD;

	Init = WIDSC;
	AlarmGeneration = WIDSC;
	WIDSC.ThreatDetection -> TD;
	WIDSC.SystemInfo -> TD;
	WIDSC.NetworkUtility -> NA;
	WIDSC.RemoteDetection -> RD.RemoteOutput;
}
