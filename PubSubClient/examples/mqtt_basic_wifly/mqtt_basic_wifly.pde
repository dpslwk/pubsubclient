/*
 Basic MQTT example 
 
  - connects to an MQTT server
  - publishes "hello world" to the topic "outTopic"
  - subscribes to the topic "inTopic"
  
  Compatibly WiFly Libary can be found here https://github.com/dpslwk/WiFly
  Current WiFly Libary only supports DHCP out the box
  This version is based around the RN-XV on a Cisceo XBEE Shield
  The RN-XV on the xbee shield talks over the hardware serial line 
  so debuging my require a SoftSerial
  The Ciseco Shiled require pin 8 HIGH before powering up the RN-XV
  
*/

#include <SPI.h>
#include <WiFly.h>
#include <PubSubClient.h>

#include "Credentials.h"

// Update these with values suitable for your network.
byte server[] = { 10, 0, 0, 2 };


void callback(char* topic, byte* payload, unsigned int length) {
  // handle message arrived
}

WiFlyClient wiFlyClient;
PubSubClient client(server, 1883, callback, wiFlyClient);

void setup()
{
    
  pinMode(8,OUTPUT);    // power up the XBee socket
  digitalWrite(8,HIGH);
  // lots of time for the WiFly to start up
  delay(10000);
  
    
  Serial.begin(9600);   // Start hardware Serial for the RN-XV
  WiFly.setUart(&Serial); // Tell the WiFly library that we are not using the SPIUart

    
  WiFly.begin();

  // Join the WiFi network
  if (!WiFly.join(ssid, passphrase, mode)) {
      while (1) {
          // Hang on failure.
      }
  } 
    
  if (client.connect("arduinoClient")) {
    client.publish("outTopic","hello world");
    client.subscribe("inTopic");
  }
}

void loop()
{
  client.loop();
}

