import { LightningElement } from "lwc";
import herokuCall from "@salesforce/apex/ucl_NightlyProcessor.herokuCall";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class importDataButton extends LightningElement {
  clickedButtonLabel;

  handleClick(event) {
    this.clickedButtonLabel = event.target.label;

    herokuCall()
      .then((result) => {
        // Log de éxito
        console.log("Éxito", result);

        // Mostrar mensaje de éxito
        this.showToast(
          "Éxito",
          "Datos importados exitosamente desde Heroku",
          "success"
        );
      })
      .catch((error) => {
        // Log de error
        console.error("Error al importar datos:", error);

        // Mostrar mensaje de error
        const errorMessage = error.body
          ? error.body.message
          : "Error desconocido";
        this.showToast(
          "Error",
          `Error al importar datos: ${errorMessage}`,
          "error"
        );
      });
  }

  showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(toastEvent);
  }
}
