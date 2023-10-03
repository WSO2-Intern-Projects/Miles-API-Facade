import ballerina/http;
import ballerina/xmldata;

// configurable string BritishAirwaysFlyerMilesServiceEndpoint = ?;
configurable string BritishAirwaysFlyerMilesServiceClientId = ?;
configurable string BritishAirwaysFlyerMilesServiceClientSecret = ?;
configurable string BritishAirwaysFlyerMilesServiceTokenUrl = ?;

// configurable string QatarAirwaysFlyerMilesServiceEndpoint = ?;
configurable string QatarAirwaysFlyerMilesServiceClientId = ?;
configurable string QatarAirwaysFlyerMilesServiceClientSecret = ?;
configurable string QatarAirwaysFlyerMilesServiceTokenUrl = ?;

public type ServiceRequest record {
    string passengerName;
    string bookReference;
};

service / on new http:Listener(9090) {
    // Define your resource functions here
    resource function get checkNIC/[string cusid]() returns json|error? {
        http:Client BritishAirwaysFlyerMilesServiceEndpoint = check new ("https://b48cc93e-fa33-4420-a155-bc653b4d46be-dev.e1-us-east-azure.choreoapis.dev/hwqf/britishairwaysflyermilesservice/britishairwaysflyermiles-8b1/v1",
            auth = {
                tokenUrl: BritishAirwaysFlyerMilesServiceTokenUrl,
                clientId: BritishAirwaysFlyerMilesServiceClientId,
                clientSecret: BritishAirwaysFlyerMilesServiceClientSecret
            }
        );

        http:Client QatarAirwaysFlyerMilesServiceEndpoint = check new ("https://b48cc93e-fa33-4420-a155-bc653b4d46be-dev.e1-us-east-azure.choreoapis.dev/hwqf/qatarariwaysflyermilesservice/flyermilesservice-dba/v1",
            auth = {
                tokenUrl: QatarAirwaysFlyerMilesServiceTokenUrl,
                clientId: QatarAirwaysFlyerMilesServiceClientId,
                clientSecret: QatarAirwaysFlyerMilesServiceClientSecret
            }
        );
        json[] responseList = [];

        xml BritishAirwaysFlyerMilesServiceResponse = check BritishAirwaysFlyerMilesServiceEndpoint->get(string `/FlyerMilesService/milesFlown/${cusid}`);
        json BritishAirwaysFlyerMilesServiceResponseJson = check xmldata:toJson(BritishAirwaysFlyerMilesServiceResponse);
        responseList.push(BritishAirwaysFlyerMilesServiceResponseJson);

        xml QatarAirwaysFlyerMilesServiceResponse = check QatarAirwaysFlyerMilesServiceEndpoint->get(string `/milesFlown/${cusid}`);
        json QatarAirwaysFlyerMilesServiceResponseJson = check xmldata:toJson(QatarAirwaysFlyerMilesServiceResponse);
        responseList.push(QatarAirwaysFlyerMilesServiceResponseJson);

        json aggregatedResponse = {"checkInInfo": responseList};
        return aggregatedResponse;
    }
}
