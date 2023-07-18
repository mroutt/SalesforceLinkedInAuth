import { LightningElement } from 'lwc';
import getProfilePhoto from '@salesforce/apex/LinkedInPhotoButtonController.getProfilePhoto';

export default class LinkedInPhotoButton extends LightningElement {

    getPhoto() {
        getProfilePhoto().then(() => { 
            console.log('getProfilePhoto called with no errors');
        }).catch((error) => {
            console.log('getProfilePhoto error = ' + JSON.stringify(error));
        });
    }
}