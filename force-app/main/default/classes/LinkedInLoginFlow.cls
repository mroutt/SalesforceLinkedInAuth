public with sharing class LinkedInLoginFlow {

    @InvocableMethod(label='Update Profile Photo from LinkedIn' description='Gets the profile photo from LinkedIn API and saves it for the User')
    public static void updateUserPhoto() {

        System.debug('LinkedInPhoto.updateUserPhoto() was called.');
        
        string accessToken = getAccessToken();

        System.debug('updateUserPhoto() called with accessToken: ' + accessToken);
        string imageInfoUrl = 'https://api.linkedin.com/v2/me?projection=(id,profilePicture(displayImage~digitalmediaAsset:playableStreams))';

        try {

            HTTPResponse photoInfoResponse = makeHttpRequest(imageInfoUrl, accessToken);

            string imageURL = getImageUrlFromResponse(photoInfoResponse);

            HTTPResponse photoResponse = makeHttpRequest(imageURL, accessToken);

            savePhoto(photoResponse);

        } catch (Exception e) {

            System.debug('Exception thrown in updateUserPhoto() with message: ' + e.getMessage());

        }
    }

    private static HTTPResponse makeHttpRequest(string url, string accessToken) {
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);

        Http http = new Http();
        return http.send(req);
    }

    private static string getImageUrlFromResponse(HTTPResponse response) {

        JSONParser parser = JSON.createParser(response.getBody());
        List<string> identifiers = new List<string>();

        while(parser.nextToken() != null) {

            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                if(parser.getText() == 'identifier') {
                    parser.nextToken();
                    string idValue = parser.getText();
                    identifiers.add(idValue);
                    System.debug('Found identifier with value: ' + idValue);
                }
            }
        }

        // The LinkedIn API returns urls for several versions of the same photo.
        // Typically the first url in the list is the lowest resolution, and the
        // last url is the highest. You can decide which version to use depending
        // on your application.
        return identifiers.get(0);
    }

    private static string getAccessToken(){

        string accessToken = '';

        try {
            
            List<AuthProvider> providers = [SELECT Id FROM AuthProvider WHERE DeveloperName = 'LinkedIn'];
            AuthProvider provider = providers.get(0);
        
            System.debug('About to call AuthToken.getAccessToken with provider ID: ' + provider.Id);
            accessToken = Auth.AuthToken.getAccessToken(provider.Id, 'LinkedIn');
        
            System.debug('Access token from LinkedIn is: ' + accessToken);

        } catch (Exception e) {
            System.debug('Error in getAccessToken(): ' + e.getMessage());
        }

        return accessToken;
    }

    private static void savePhoto(HttpResponse photoResponse) {

        Blob photoBlob = photoResponse.getBodyAsBlob();

        System.debug('Blob retrieved with size: ' + photoBlob.size());

        string imageFileName = UserInfo.getName() +'.jpg';
        string userId = UserInfo.getUserId(); 

        System.debug('About to upload image file for user ' + UserInfo.getName());
        ConnectApi.BinaryInput fileUpload = new ConnectApi.BinaryInput(photoBlob, 'image/jpg', imageFileName);
        System.debug('File uploaded with file name: ' + fileUpload.getFilename());
        ConnectApi.UserProfiles.setPhoto(null, userId,  fileUpload);
        System.debug('Photo set');
    }
}