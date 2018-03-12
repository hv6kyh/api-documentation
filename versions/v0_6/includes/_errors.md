# Errors

The Deepomatic API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Your request is badly formatted
401 | Unauthorized -- Your API key is wrong
403 | Forbidden -- You are not authorized to access this endpoint
404 | Not Found -- The specified resource could not be found
405 | Method Not Allowed -- You tried to access a endpoint with an invalid method
410 | Gone -- The resource requested has been removed from our servers
429 | Too Many Requests -- You're requesting too many requests! Slow down!
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
