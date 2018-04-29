

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
		interface Notify<wids_observable_t> as RemoteDetection;

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

		interface GetNow<bool> as CCA;

		interface Alarm<TSymbolIEEE802154,uint32_t> as GTSAlarm;
		interface IEEE154Frame;
	}

} implementation {

	components CC2420ThreatDetectionP;

	ThreatDetection = CC2420ThreatDetectionP;
	SystemInfo = CC2420ThreatDetectionP;

	components NetworkAdapterP;
	NetworkUtility = NetworkAdapterP;

	components RemoteDetectionP;
	RemoteDetection = RemoteDetectionP;

	RadioRx = CC2420ThreatDetectionP.RX;
	RadioTx = CC2420ThreatDetectionP.TX;
	SlottedCsmaCa = CC2420ThreatDetectionP.SCsma;
	UnslottedCsmaCa = CC2420ThreatDetectionP.UnCsma;

	RTx = CC2420ThreatDetectionP.RadioTx;
	SCsmaCa = CC2420ThreatDetectionP.SlottedCsmaCa;
	UCsmaCa = CC2420ThreatDetectionP.UnslottedCsmaCa;
	RRx = CC2420ThreatDetectionP.RadioRx;

	CCA = CC2420ThreatDetectionP.CCA;
	IEEE154Frame = CC2420ThreatDetectionP.IEEE154Frame;

	GTSAlarm = CC2420ThreatDetectionP.Alarm;

	components new HashMapC(uint16_t, uint16_t, 10), new ModHashP(10);
	HashMapC.Hash -> ModHashP;

	CC2420ThreatDetectionP.SEQNO -> HashMapC;

	components CC2420ReceiveC;

	CC2420ThreatDetectionP.CC2420Failures -> CC2420ReceiveC;

	components WIDSC, NetworkAdapterP as NA, RemoteDetectionP as RD;

	Init = WIDSC;
	AlarmGeneration = WIDSC;
	WIDSC.ThreatDetection -> CC2420ThreatDetectionP;
	WIDSC.SystemInfo -> CC2420ThreatDetectionP;
	WIDSC.NetworkUtility -> NA;
	WIDSC.RemoteDetection -> RD.RemoteOutput;

	// comment the following in real use of the product
	components EvaluationC, new Timer62500C(), RandomC, MainC;
	WIDSC.RemoteDetection -> EvaluationC;
	EvaluationC.Timer -> Timer62500C;
	EvaluationC.Random -> RandomC;
	EvaluationC.Boot -> MainC;
}
