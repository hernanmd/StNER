"
Download the server from : https://nlp.stanford.edu/software/CRF-NER.html#Download

Start the Java server with default parameters. Providing path location is mandatory. If no host or port is supplied, defaults to localhost (127.0.0.1) and port 8080.

Usage example in UNIX/MacOS

```
StSocketNERServer new 
	stanfordNERPath: 'stanford-ner-2020-11-17';
	startServer.
```

Or from CLI

```
java -mx1000m -cp ""stanford-ner-2020-11-17/stanford-ner.jar"" edu.stanford.nlp.ie.NERServer -loadClassifier stanford-ner-2020-11-17/classifiers/english.all.3class.distsim.crf.ser.gz -port 8080 -outputFormat inlineXML
```

Usage example in Windows:

```
StSocketNERServer new 
	stanfordNERPath: 'c:\stanford-ner-2015-01-30\';
	startServer.
```
"
Class {
	#name : 'StSocketNERServer',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'outputFormat',
		'classifier',
		'stanfordNERPath',
		'jarClass',
		'memory'
	],
	#category : 'StNER-Core',
	#package : 'StNER-Core'
}

{ #category : 'private' }
StSocketNERServer >> buildCommandLine [

	^ String streamContents: [ : stream |
		stream nextPutAll: 'java -mx';
			nextPutAll: self memory;
			nextPutAll: ' -cp ';
			nextPutAll: (self jarClass surroundedBy: ($" asString));
			nextPutAll: ' edu.stanford.nlp.ie.NERServer -loadClassifier ';
			nextPutAll: (self classifier surroundedBy: ($" asString));
			nextPutAll: ' -port ';
			nextPutAll: self port asString;
			nextPutAll: ' -outputFormat ';
			nextPutAll: self outputFormat ]

]

{ #category : 'private' }
StSocketNERServer >> classifier [
	"Answer a <String> referencing the classifier used for the receiver"
	
	^ classifier
		ifNil: [ 
			self setEnglish3ClassTagger.
			classifier ]
]

{ #category : 'private' }
StSocketNERServer >> classifier: aFilename [
	" Private - Set the receiver's classifier model to be aFilename "

	classifier := self classifiersPath , self pathSeparator , aFilename
]

{ #category : 'private' }
StSocketNERServer >> classifiersPath [
	" Answer a <String> referencing the classifiers folder "

	^ self stanfordNERPath , 'classifiers'
]

{ #category : 'private' }
StSocketNERServer >> directoryExists: path [
	"Answer true if a directory of the given name exists. The given name may
	be either a full path name or a local directory within this directory."

	^ self useFileSystem
		ifTrue: [ (path perform: #asFileReference) exists ]
		ifFalse: [ (Smalltalk at: #FileDirectory) default directoryExists: path ]

]

{ #category : 'accessing' }
StSocketNERServer >> host [
	^ host
		ifNil: [ host := 'localhost' ]
]

{ #category : 'accessing' }
StSocketNERServer >> host: anObject [
	host := anObject
]

{ #category : 'accessing' }
StSocketNERServer >> jarClass [
	^ jarClass
		ifNil: [ jarClass := self stanfordNERPath , 'stanford-ner.jar' ]

]

{ #category : 'accessing' }
StSocketNERServer >> jarClass: anObject [
	jarClass := anObject
]

{ #category : 'accessing' }
StSocketNERServer >> memory [
	" Answer a <String> with the allowed memory for the JVM to run "

	^ memory
		ifNil: [ memory := '1000m' ]
]

{ #category : 'accessing' }
StSocketNERServer >> memory: anObject [
	memory := anObject
]

{ #category : 'accessing' }
StSocketNERServer >> outputFormat [
	^ outputFormat
		ifNil: [ outputFormat := 'inlineXML' ]
]

{ #category : 'accessing' }
StSocketNERServer >> outputFormat: anObject [
	outputFormat := anObject
]

{ #category : 'private' }
StSocketNERServer >> pathSeparator [

	^ self useFileSystem
		ifTrue: [((Smalltalk at: #DiskStore) current perform: #delimiter) asString]
		ifFalse: [(Smalltalk at: #FileDirectory) slash]

]

{ #category : 'accessing' }
StSocketNERServer >> port [
	^ port
		ifNil: [ port := 8080 ]
]

{ #category : 'accessing' }
StSocketNERServer >> port: anObject [
	port := anObject
]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish3ClassCaselessTagger [
	" Use a  trained only on data from MUC and distinguishes between 3 different caseless classes"

	self classifier: 'english.all.3class.caseless.distsim.crf.ser.gz '
]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish3ClassTagger [
	" Use a 3 class NER tagger that can label: PERSON, ORGANIZATION, and LOCATION entities."

	self classifier: 'english.all.3class.distsim.crf.ser.gz'

]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish4ClassCaselessTagger [
	" Use a  4 class NER tagger trained on the CoNLL 2003 Shared Task training data that labels for PERSON, ORGANIZATION, LOCATION, and MISC"

	self classifier: 'english.conll.4class.caseless.distsim.crf.ser.gz'

]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish4ClassTagger [
	" Use a  4 class NER tagger trained on the CoNLL 2003 Shared Task training data that labels for PERSON, ORGANIZATION, LOCATION, and MISC"

	self classifier: 'english.conll.4class.distsim.crf.ser.gz'

]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish7ClassCaselessTagger [
	" Use a  trained only on data from MUC and distinguishes between 7 different caseless classes"

	self classifier: 'english.muc.7class.caseless.distsim.crf.ser.gz'
]

{ #category : 'accessing' }
StSocketNERServer >> setEnglish7ClassTagger [
	" Use a  trained only on data from MUC and distinguishes between 7 different classes"

	self classifier: 'english.all.7class.distsim.crf.ser.gz'

]

{ #category : 'accessing' }
StSocketNERServer >> stanfordNERPath [
	" Answer a <String> with the location of the Stanford NER classifier, or where stanford-ner.jar is located "
	^ stanfordNERPath
]

{ #category : 'accessing' }
StSocketNERServer >> stanfordNERPath: aString [
	" Set the receiver's path to be aString "

	| fullPath |
	self assert: (self directoryExists: aString).
	fullPath := aString trimBoth.
	aString last = self pathSeparator
		ifFalse: [ fullPath := aString , self pathSeparator ].
	stanfordNERPath := fullPath
]

{ #category : 'accessing' }
StSocketNERServer >> startServer [
	" Start the Stanford NER server process and answer its command line output  "

	OSPlatform current isWindows ifTrue: [ ^ self startServerInWindows ].
	(OSPlatform current isUnix or: [ OSPlatform current isMacOSX ]) ifTrue: [ ^ self startServerInUnix ].
	^ 'Cannot start server'
]

{ #category : 'private' }
StSocketNERServer >> startServerInUnix [
	" Start process and answer its output "

	^ (OSSUnixSubprocess new command:  self buildCommandLine)
		workingDirectory: self stanfordNERPath
]

{ #category : 'private' }
StSocketNERServer >> startServerInWindows [
	" Start process and answer its output "

	^ (Smalltalk at: #OSWinSubprocess) new 
		command: self buildCommandLine;
		workingDirectory: self stanfordNERPath
]

{ #category : 'private' }
StSocketNERServer >> useFileSystem [
	"If true use FileSystem, otherwise use traditional FileDirectory. See senders
	for methods with file system dependencies."

	^ Smalltalk hasClassNamed: #FileReference
]
