### Faxes

#### About Faxes

#### Schema

Key | Description | Type | Default | Required
--- | ----------- | ---- | ------- | --------
`attempts` | The number of attempts made, this will be set by the system and reset automaticly on put/post | `integer` | `0` | `false`
`document` | Parameters related to the storage of a fax document | `object` |   | `false`
`document.content` | The content provided in the body when fetching for transmission as a post | `string(0..256)` |   | `false`
`document.content_type` | The content type header to be used when fetching for transmission as a post | `string` |   | `false`
`document.host` | The host header to be used when fetching for transmission | `string` |   | `false`
`document.method` | The method that should be used to reteive the document | `string('get', 'post')` | `get` | `false`
`document.referer` | The referer header to be used when fetching for transmission | `string` |   | `false`
`document.url` | The url of the fax document | `string` |   | `false`
`from_name` | The sender name for the fax | `string` |   | `false`
`from_number` | The sender number for the fax | `string` |   | `false`
`notifications` | Status notifications | `object` |   | `false`
`notifications.email` | Email notifications | `object` |   | `false`
`notifications.email.send_to` | A list or string of email recipent(s) | `string, array(string)` |   | `false`
`notifications.sms` | SMS notifications | `object` |   | `false`
`notifications.sms.send_to` | A list or string of sms recipent(s) | `string, array(string)` |   | `false`
`retries` | The number of times to retry | `integer` | `1` | `false`
`to_name` | The recipient name for the fax | `string` |   | `false`
`to_number` | The recipient number for the fax | `string` |   | `false`
`tx_result` | The result of a transmission attempt | `object` | `{}` | `false`
`tx_result.error_message` | A description of any error that occured | `string` | "" | `false`
`tx_result.fax_bad_rows` | The number of bad rows | `integer` | `0` | `false`
`tx_result.fax_error_correction` | True if fax error correction was used | `boolean` | `false` | `false`
`tx_result.fax_receiver_id` | The receiver id reported by the remote fax device | `string` | "" | `false`
`tx_result.fax_speed` | The speed achieved during transmission | `integer` | `0` | `false`
`tx_result.pages_sent` | The number of pages transmitted | `integer` | `0` | `false`
`tx_result.success` | True if the fax transmission was successful | `boolean` | `false` | `false`
`tx_result.time_elapsed` | The amount of time from submition to completion | `integer` | `0` | `false`


#### Create

> PUT /v2/accounts/{ACCOUNT_ID}/faxes

```curl
curl -v -X PUT \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/outgoing

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outgoing
```

#### Create

> PUT /v2/accounts/{ACCOUNT_ID}/faxes/outgoing

```curl
curl -v -X PUT \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outgoing
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/outbox

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/incoming

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/incoming
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/inbox

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/inbox
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/smtplog

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/smtplog
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/outgoing/{FAXJOB_ID}

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outgoing/{FAXJOB_ID}
```

#### Remove

> DELETE /v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}

```curl
curl -v -X DELETE \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}
```

#### Change

> PUT /v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}

```curl
curl -v -X PUT \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}
```

#### Remove

> DELETE /v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}

```curl
curl -v -X DELETE \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/incoming/{FAX_ID}

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/incoming/{FAX_ID}
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/smtplog/{ATTEMPT_ID}

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/smtplog/{ATTEMPT_ID}
```

#### Remove

> DELETE /v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}/attachment

```curl
curl -v -X DELETE \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}/attachment
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}/attachment

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/outbox/{FAX_ID}/attachment
```

#### Remove

> DELETE /v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}/attachment

```curl
curl -v -X DELETE \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}/attachment
```

#### Fetch

> GET /v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}/attachment

```curl
curl -v -X GET \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/faxes/inbox/{FAX_ID}/attachment
```

