@echo off
echo Downloading libraries for offline use...

mkdir www\lib 2>nul

echo Downloading SheetJS...
curl -L -o www\lib\xlsx.full.min.js https://cdn.sheetjs.com/xlsx-0.20.1/package/dist/xlsx.full.min.js

echo Downloading jsPDF...
curl -L -o www\lib\jspdf.umd.min.js https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js

echo Downloading jsPDF AutoTable...
curl -L -o www\lib\jspdf.plugin.autotable.min.js https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.1/jspdf.plugin.autotable.min.js

echo.
echo All libraries downloaded to www\lib\
echo.
pause