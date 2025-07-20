"
A StSocketNERClientTest is a test class for testing the behavior of StSocketNERClient
"
Class {
	#name : 'StSocketNERClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'tagger'
	],
	#category : 'StNER-Tests',
	#package : 'StNER-Tests'
}

{ #category : 'accessing' }
StSocketNERClientTest >> setUp [

	self tagger: StSocketNERClient new 
]

{ #category : 'accessing' }
StSocketNERClientTest >> tagger [
	^ tagger
]

{ #category : 'accessing' }
StSocketNERClientTest >> tagger: anObject [
	tagger := anObject
]

{ #category : 'tests-accessing' }
StSocketNERClientTest >> testParseText [

	| parseResult |
	
	parseResult := self tagger parseText: 'University of California is located in California, United States'.
	self assert: (parseResult isKindOf: Dictionary).
	self assert: (parseResult includesKey: 'LOCATION').
	self assert: (parseResult includesKey: 'ORGANIZATION').
	self assert: ((parseResult at: 'LOCATION') isKindOf: Bag).
	self assert: ((parseResult at: 'LOCATION') occurrencesOf: 'California') = 2.
	self assert: ((parseResult at: 'ORGANIZATION') isKindOf: Bag).
	self assert: ((parseResult at: 'ORGANIZATION') occurrencesOf: 'University of California') = 1.


]

{ #category : 'tests-accessing' }
StSocketNERClientTest >> testTagText [

	self assert: (self tagger tagText: 'University of California is located in California, United States') = 
'<ORGANIZATION>University of California</ORGANIZATION> is located in <LOCATION>California</LOCATION>, <LOCATION>United States</LOCATION>'.
	self assert: (self tagger tagText: '') = ''.
]
