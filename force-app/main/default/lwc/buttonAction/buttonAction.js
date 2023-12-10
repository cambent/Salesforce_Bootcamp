import { LightningElement } from 'lwc';
import ucl_NightlyProcessor from '@salesforce/apex/ucl_NightlyProcessor.herokuCall';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ButtonAction extends LightningElement {
    clickedButtonLabel;


    handleClick(event) {
        this.clickedButtonLabel = event.target.label;
        ucl_NightlyProcessor()
            .then(result => {
                this.showToast('Éxito', 'Datos importados exitosamente desde Heroku', 'success');
            })
            .catch(error => {
                this.showToast('Error', `Error al importar datos: ${error.body.message}`, 'error');
            });
    }
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }