#pragma once
#import <FunSDK/JObject.h>
#include "EventHandler.h"
#include "PirTimeSection.h"

#define JK_Alarm_PIR "Alarm.PIR" 
class Alarm_PIR : public JObject
{
public:
	JBoolObj		Enable; //开关
	EventHandler		mEventHandler;
	JIntObj		Level; //灵敏度
	JIntObj		PIRCheckTime; //触发时长 （徘徊多久才会触发徘徊检测）
	PirTimeSection		mPirTimeSection;

public:
    Alarm_PIR(JObject *pParent = NULL, const char *szName = JK_Alarm_PIR):
    JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"),
	Level(this, "Level"),
	PIRCheckTime(this, "PIRCheckTime"),
	mPirTimeSection(this, "PirTimeSection"){
	};

    ~Alarm_PIR(void){};
};
