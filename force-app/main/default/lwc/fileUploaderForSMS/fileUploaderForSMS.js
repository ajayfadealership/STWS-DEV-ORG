import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderForSMS.uploadFile'
export default class FileUploaderCompLwc extends LightningElement {
    @track fileData ;
    @track body ;
    @track strbase64 ;
    @track strName ;
    @track error;
    @track loading = false;
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
          /*  this.fileData = {
                'filename': file.name,
                'base64': base64
               
            } */

            this.strbase64 = base64;
            this.strName = file.name;
           // alert(JSON.stringify(this.fileData));
           
        }
        reader.readAsDataURL(file)
    }
    handleNumberChange(event){
        this.body = event.target.value;
     }

    handleClick(event){
      //  const {base64, filename} = this.fileData;
      this.loading = true;
        uploadFile({ base64 : this.strbase64   , filename :  this.strName , strBody : this.body})
         .then(result=>{
            this.loading = false;
            this.fileData = null
            let title =  'uploaded successfully!!'
            this.toast(title)
        })  
        .catch(error => {
            this.loading = false;
            this.error = error;
        });
    }

    toast(title){
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)
    }
}