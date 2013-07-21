FlexPDFViewer
=============

Project Summary:

There is no easy way to view a pdf in flex. I am going to explain how I hv done it. In my project there is a directory 
named "soft" and in this directory there is an executable named "swftools-0.9.0.exe". I hv download it from 
http://www.swftools.org/download.html. I hv used swftools to generate swf file from pdf. and after that I hv 
loaded the swf as an external swf file in project swf.

If we load the external swf as SWFLoader we cannot handle page by page. So If we want to control the swf then we need to 
load it as streamLoader. I hv found a class name "ForcibleLoader" from 
http://www.libspark.org/svn/as3/ForcibleLoader/src/org/libspark/utils/ForcibleLoader.as. it can load a swf as urlStream
but there is a problem for forcibleLoader that it cannot load one paged document. Only Loader class can load document 
but multipaged document has some problem so when there is multiple page I hv used ForcibleLoader and if there is one page 
then I used Loader.

If I want to take decision whether the document is mutipaged or single paged then I need to collect the infromation. So 
to get the information of total frames/page I have used as3Swf from https://github.com/claus/as3swf


