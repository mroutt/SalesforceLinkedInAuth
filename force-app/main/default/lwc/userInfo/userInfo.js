import { LightningElement, wire } from 'lwc';
import userId from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_EMAIL_FIELD from '@salesforce/schema/User.Email';
import USER_MEDIUM_PHOTO_FIELD from '@salesforce/schema/User.MediumPhotoUrl';

export default class UserInfo extends LightningElement {

    userName;
    userEmail;
    imageUrl;

    @wire(getRecord, { recordId: userId, fields: [USER_NAME_FIELD, USER_EMAIL_FIELD, USER_MEDIUM_PHOTO_FIELD]}) 
    currentUserInfo({error, data}) {

        if(data) {
            this.userName = data.fields.Name.value;
            this.userEmail = data.fields.Email.value;
            this.imageUrl = data.fields.MediumPhotoUrl.value;
        } else if (error) {
            console.log(error);
        }
    }
}