import { LightningElement, api, wire } from 'lwc';
import XMLgen from '@salesforce/apex/SupremeSoftwareXMLGenerate.XMLgen';

export default class DownloadXMLFile extends LightningElement {
    @api recordId;

    @wire(XMLgen, {recordId: '$recordId'})
    wiredResult({data, error}){
        if(data){
            console.log(data)
        }
        if(error){
            console.log(error)
        }
    }
}