import { LightningElement } from 'lwc';
import searchPart from '@salesforce/apex/PartSearchTabController.searchPart';

const columnsWO = [
    {
        label: 'Part Name',
        fieldName: 'partName',
        editable: true
    }, {
        label: 'Part Number',
        fieldName: 'partNumber',
        editable: true

    }, {
        label: 'Quantity',
        fieldName: 'quantity',
        editable: true

    }, {
        label: 'Price',
        fieldName: 'price',
        editable: true
    }
];

const columnsOrder = [
    {
        label: 'Part Cost',
        fieldName: 'partCost1',
        editable: true
    }, {
        label: 'Part Number',
        fieldName: 'partNumber3',
        editable: true

    }, {
        label: 'Part Size',
        fieldName: 'partSize',
        editable: true

    }, {
        label: 'Name',
        fieldName: 'name',
        editable: true
    }
];

const columnsInvoice = [
    {
        label: 'Part Cost',
        fieldName: 'partCost',
        editable: true
    }, {
        label: 'Part Number',
        fieldName: 'partNumber1',
        editable: true

    }, {
        label: 'Quantity',
        fieldName: 'quantity1',
        editable: true

    }, {
        label: 'Total Price',
        fieldName: 'totalPrice',
        editable: true
    }
];

export default class PartSearchTab extends LightningElement {
    value;
    partSearch;
    searchResult;
    searchResultWO;
    searchResultorder;
    searchResultinvoice;
    selectedOption;
    columnsWO = columnsWO;
    columnsInvoice = columnsInvoice;
    columnsOrder = columnsOrder;

    get options() {
        return [
            { label: 'All', value: 'All' },
            { label: 'Work Order', value: 'workOrder' },
            { label: 'Order', value: 'order' },
            { label: 'Purchase Order', value: 'purchaseOrder' },
            { label: 'Invoice', value: 'invoice' },
        ];
    }

    handleChange(event) {
        this.selectedOption = event.detail.value;
        if((this.selectedOption) == 'workOrder'){
            this.searchResultWO = true;
            this.searchResultorder = false;
            this.searchResultinvoice = false;
        }else if(this.selectedOption == 'All'){
            this.searchResultWO = true;
            this.searchResultorder = true;
            this.searchResultinvoice = true;
        }else if(this.selectedOption == 'order'){
            this.searchResultWO = false;
            this.searchResultorder = true;
            this.searchResultinvoice = false;
        }else if(this.selectedOption == 'purchaseOrder'){
            this.searchResultWO = false;
            this.searchResultorder = true;
            this.searchResultinvoice = false;
        }else if(this.selectedOption == 'invoice'){
            this.searchResultWO = false;
            this.searchResultorder = false;
            this.searchResultinvoice = true;
        }
    }
    handlePartSearch(event){
        this.partSearch = event.target.value;
    }
    handleClick(){

        console.log('>>>>>partsearch:::',this.partSearch);
        console.log('>>>>>selected option:::',this.selectedOption);
        searchPart({
            partNo: this.partSearch,
            selected: this.selectedOption
        })
        .then(result =>{
            this.searchResult = result;
            console.log(result);
        })
        .catch(error =>{
            this.error = error;
        })
    }
}