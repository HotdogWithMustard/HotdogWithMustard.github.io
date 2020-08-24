#NoEnv
#SingleInstance, Force

BasePath := A_WorkingDir
FormatTime, DateTime, , % "MM-dd-yyyy hh:mm:ss"

CacheFile := "Cache.appcache"
CacheFilePath := BasePath "\" CacheFile

if (FileExist(CacheFilePath))
{
	FileDelete, % CacheFilePath
}

FileAppend, % "CACHE MANIFEST`n", % CacheFilePath
FileAppend, % "# " DateTime "`n`n", % CacheFilePath
FileAppend, % CacheFile "`n", % CacheFilePath

For Index, FilePattern in [ "*.html", "*.css", "*.js", "Payloads\*.bin" ]
{
	Loop Files, % BasePath "\" FilePattern
	{
		RelativePath := SubStr(A_LoopFileDir, StrLen(BasePath) + 2)
		FileAppend, % (StrLen(RelativePath) > 0 ? UrlEncode(RelativePath) "/" : "") UrlEncode(A_LoopFileName) "`n", % CacheFilePath
	}
}

UrlEncode(String)
{
	OldFormat := A_FormatInteger
	SetFormat, Integer, H
	
	Loop, Parse, String
	{
		if A_LoopField is alnum
		{
			Out .= A_LoopField
			continue
		}
		
		if (RegExMatch(A_LoopField, "^[-$_.+!*'(),]$"))
		{
			Out .= A_LoopField
			continue
		}
		
		Hex := SubStr( Asc( A_LoopField ), 3 )
		Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
	}
	
	SetFormat, Integer, %OldFormat%
	return Out
}