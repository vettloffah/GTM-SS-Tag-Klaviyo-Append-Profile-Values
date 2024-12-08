___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Klaviyo Append Customer Properties",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "PARAM_TABLE",
    "name": "dataToAppend",
    "displayName": "",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "key",
          "displayName": "Key",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "value",
          "displayName": "Value",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "Klaviyo API Key",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "email",
    "displayName": "Email",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const getRequestHeader = require('getRequestHeader');
const getRemoteAddress = require('getRemoteAddress');
const traceId = getRequestHeader('trace-id');
const klaviyoApiRevision = '2024-06-15';

apiCall();

function apiCall() {
  let appendObj = {};
  // add key / value pairs to klaviyo append data
  data.dataToAppend.forEach((obj) => {
    appendObj[obj.key] = obj.value;
  });
  // send request
  sendHttpRequest(
    'https://a.klaviyo.com/api/profile-import/',
    (statusCode, headers, body) => {
      logToConsole(
        JSON.stringify({
          Name: 'Klaviyo',
          Type: 'Response',
          TraceId: traceId,
          EventName: 'profile-import',
          ResponseStatusCode: statusCode,
          ResponseHeaders: headers,
          ResponseBody: body
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
        'X-Forwarded-For': getRemoteAddress(),
        'Content-Type': 'application/json',
        Accept: 'application/json',
        Revision: klaviyoApiRevision,
        Authorization: 'Klaviyo-API-Key ' + data.apiKey
      },
      method: 'POST'
    },
    JSON.stringify({
      data: {
        type: 'profile',
        attributes: {
          email: data.email
        },
        meta: {
          patch_properties: {
            append: appendObj
          }
        }
      }
    })
  );
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 12/8/2024, 11:05:46 AM


