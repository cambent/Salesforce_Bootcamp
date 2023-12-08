import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LEGAL_ADVISOR_OBJECT from '@salesforce/schema/LegalAdvisor';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_NUMBER_FIELD from '@salesforce/schema/Account.Number';
import ACCOUNT_STATUS_FIELD from '@salesforce/schema/Account.Status';
export default class AccountUpdated extends LightningElement {
    objectApiName = LEGAL_ADVISOR_OBJECT;
    fields = [ACCOUNT_NAME_FIELD, ACCOUNT_NUMBER_FIELD, ACCOUNT_STATUS_FIELD];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Lagal Account Updated",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}
