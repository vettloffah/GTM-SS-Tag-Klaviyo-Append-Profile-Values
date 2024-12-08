const sendHttpRequest = require("sendHttpRequest");
const JSON = require("JSON");
const logToConsole = require("logToConsole");
const getRequestHeader = require("getRequestHeader");
const getRemoteAddress = require("getRemoteAddress");
const traceId = getRequestHeader("trace-id");
const klaviyoApiRevision = "2024-06-15";

apiCall();

function apiCall() {
  let appendObj = {};
  // add key / value pairs to klaviyo append data
  data.dataToAppend.forEach((obj) => {
    appendObj[obj.key] = obj.value;
  });
  // send request
  sendHttpRequest(
    "https://a.klaviyo.com/api/profile-import/",
    (statusCode, headers, body) => {
      logToConsole(
        JSON.stringify({
          Name: "Klaviyo",
          Type: "Response",
          TraceId: traceId,
          EventName: "profile-import",
          ResponseStatusCode: statusCode,
          ResponseHeaders: headers,
          ResponseBody: body,
        })
      );

      if (statusCode >= 200 && statusCode < 300) {
        data.gtmOnSuccess();
      } else {
        data.gtmOnFailure();
      }
    },
    {
      headers: {
        "X-Forwarded-For": getRemoteAddress(),
        "Content-Type": "application/json",
        Accept: "application/json",
        Revision: klaviyoApiRevision,
        Authorization: "Klaviyo-API-Key " + data.apiKey,
      },
      method: "POST",
    },
    JSON.stringify({
      data: {
        type: "profile",
        attributes: {
          email: data.email,
        },
        meta: {
          patch_properties: {
            append: appendObj,
          },
        },
      },
    })
  );
}
