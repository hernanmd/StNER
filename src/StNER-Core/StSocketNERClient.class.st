"
## Stanford NER over simple TCP/IP socket.

Usage example starting a server on localhost:

StSocketNERServer new startServer.

"" View raw Stanford NER server output ""

StSocketNERClient new 
	tagText: 'University of California is located in California, United States'

"" output should be: '<ORGANIZATION>University of California</ORGANIZATION> is located in <LOCATION>California</LOCATION>, <LOCATION>United States</LOCATION>' ""

"" Parse in-line XML ""

StSocketNERClient new 
	parseText: 'University of California is located in California, United States'

"
Class {
	#name : 'StSocketNERClient',
	#superclass : 'Object',
	#instVars : [
		'clientStream',
		'dataRead',
		'parser',
		'server',
		'results',
		'selectedClasses'
	],
	#category : 'StNER-Core',
	#package : 'StNER-Core'
}

{ #category : 'example' }
StSocketNERClient class >> example1 [

	^ self new tagText: 'University of California is located in California, United States'
]

{ #category : 'initialize' }
StSocketNERClient >> initialize [

	super initialize.
	clientStream := nil.

]

{ #category : 'accessing' }
StSocketNERClient >> parseText: text [ 

	parser := XMLPullParser parse: (self tagText: text).
	parser reset.
	[ parser isEndDocument ] whileFalse: [
		(parser nodesIfAny: self selectedClasses) isEmpty
			ifFalse: [ 
				| node  nodeValue |
				nodeValue := node anyOne.
				self results 
					at: nodeValue key 
					ifPresent: [: val | (self results at: nodeValue key) add: val anyOne ]
					ifAbsent: [ self results at: nodeValue key put: (Bag with: nodeValue value) ] ].
		parser next ].
	^ self results
]

{ #category : 'private' }
StSocketNERClient >> receiveTaggedText [
	" Private - See tagText: comment "

	clientStream fillReadBuffer.
	clientStream isDataAvailable
		ifTrue: [ dataRead := clientStream upToEnd asString ]
		ifFalse: [ self inform: 'No data available'.
				dataRead := '' ].
	clientStream close.
	^ dataRead
]

{ #category : 'accessing' }
StSocketNERClient >> results [
	^ results
		ifNil: [ results := Dictionary new ]
]

{ #category : 'accessing' }
StSocketNERClient >> results: anObject [
	results := anObject
]

{ #category : 'accessing' }
StSocketNERClient >> selectedClasses [
	" Answer a <Collection> of <String> each representing a 'Class' to be recognized in the raw input text " 
	
	^ selectedClasses
		ifNil: [ selectedClasses := #('ORGANIZATION' 'LOCATION' 'PERSON') ]
]

{ #category : 'private' }
StSocketNERClient >> sendText: text [

	clientStream := ZdcSocketStream openConnectionToHostNamed: self serverHost port: self serverPort.
	clientStream 
		timeout: 300;
		nextPutAll: text; 
		flush.

]

{ #category : 'accessing' }
StSocketNERClient >> server [

	^ server
		ifNil: [ server := StSocketNERServer new ]
]

{ #category : 'accessing' }
StSocketNERClient >> serverHost [
	"Return a <String> with the name where Stanford NER Server is running "
	
	^ self server host
]

{ #category : 'accessing' }
StSocketNERClient >> serverPort [
	"Return the integer port number where Stanford NER Server is listening on"
	
	^ self server port
]

{ #category : 'accessing' }
StSocketNERClient >> tagText: aString [
	" Tag the text aString with proper named entities token-by-token.
        Answer tagged text in receiver's output format "

	self sendText: aString , OSPlatform current lineEnding.
	^ self receiveTaggedText

]
