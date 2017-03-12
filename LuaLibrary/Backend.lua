-----------------------------------------------------------
-- PROJECT: MTA:TD - Test and Debug Framework
--
-- LICENSE: See LICENSE in top level directory
-- PURPOSE: The backend interface (communicates with the backend)
------------------------------------------------------------
MTATD.Backend = {}

-----------------------------------------------------------
-- Connects to the backend via HTTP
--
-- host (string): The hostname or IP
-- port (number): The port
-----------------------------------------------------------
function MTATD.Backend:connect(host, port)
    -- Build base URL
    self.baseUrl = ("http://%s:%d/"):format(host, port)

    -- Make initial request to check if the backend is running
    -- TODO
end

-----------------------------------------------------------
-- Sends a request with data to the backend
--
-- name (string): The request identifier (use <MODULE>/<action>)
-- data (table): The data that is sent to the backend
--      (must be serializable using toJSON)
-- callback (function(responseData)): Called when the
--       unserialized response arrives
-----------------------------------------------------------
function MTATD:request(name, data, callback)
    return fetchRemote(self.baseUrl..name,
        function(response, errno)
            if errno ~= 0 then
                error("Could not reach backend")
                return
            end

            -- Unserialize response and call callback
            if callback then
                callback(fromJSON(response))
            end
        end,
        toJSON(data)
    )
end

function MTATD.Backend:reportTestResults(testResults)
    -- Build JSON object
    --[[local data = {}
    for testSuite, results in pairs(testResults) do
        -- Reformat data
        -- TODO
    end]]

    self:request("MTADebug/report_test_results", testResults)
end