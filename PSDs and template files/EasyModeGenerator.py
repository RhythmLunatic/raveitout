"""
Find charts in your song folder and then create "easy mode" verisons of them, which is the same exact chart but with only singles difficulty and nothing over lv10.
Place this script inyour Songs folder and run.
AdditionalSongs is not supported.
new sscs will be placed in 99-Easy.
"""
import sys
import os
#print(os.getcwd())
#print(sys.argv[1])
with open(sys.argv[1]) as file_read:
	content = file_read.read().split("#")
	insideNoteData = False
	mainData = {}
	chartData = []
	curChart = 0
	for line in content:
		line = line.strip()
		if line == '':
			continue
			
		if (line.startswith("NOTEDATA:")): #Start of per-chart data
			insideNoteData = True
			chartData.append({})
			curChart = len(chartData)-1
			continue
		if (insideNoteData):
			k, v = line.split(":")
			chartData[curChart][k] = v
		else:
			#print(line)
			k, v = line.split(":")
			mainData[k] = v
	
	print("Found " + str(len(chartData)) + " charts.")
	
	foundOneValidChart = False
	for i in range(len(chartData)):
		#print("Chart " + str(i+1)+":")
		#print("Creator: " + chartData[i]["CREDIT"])
		#print("Style: "+ chartData[i]["STEPSTYPE"])
		#print("Meter: "+ chartData[i]["METER"])
		#print("")
		#print(chartData[i]["NOTES"])
		if chartData[i]["STEPSTYPE"] == "pump-single;":
			if int(chartData[i]["METER"][:-1]) < 10:
				foundOneValidChart = True
				break
				#numChartsUnderLv10 += 1
	
	numChartsUnderLv10 = 0
	if foundOneValidChart:
		newFile = open(os.getcwd+"/EasyMode/"+sys.argv[1], "w")
		for i in range(len(chartData)):
			if chartData[i]["STEPSTYPE"] == "pump-single;":
				if int(chartData[i]["METER"][:-1]) < 10:
					
					numChartsUnderLv10 += 1
					
