import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getExpiringEnrollments from '@salesforce/apex/ExpiringMembershipsController.getExpiringEnrollments';

const COLUMNS = [
    { label: 'Member Name', type: 'button', fieldName: 'memberName',
        typeAttributes: { label: { fieldName: 'memberName' }, name: 'open_member', variant: 'base' }
    },
    { label: 'Phone', fieldName: 'phone', type: 'text' },
    { label: 'Membership Plan', fieldName: 'planName', type: 'text' },
    { label: 'Expiry Date', fieldName: 'endDate', type: 'date'},
    { label: 'Days Left', fieldName: 'daysLeft', type: 'text'}
];

export default class ExpiringMemberships extends NavigationMixin(LightningElement) {

    columns = COLUMNS;
    allRows = [];
    rows = [];
    searchKey = '';
    errorMessage;
    isLoaded = false;

    @wire(getExpiringEnrollments)
    wiredEnrollments({ data, error }) {
        if (data) {
            this.allRows = data.map(item => ({
                id: item.Id,
                memberId: item.Member__c,
                memberName: item.Member__r.Name ?item.Member__r.Name:'N/A',
                phone: item.Member__r.Phone__c ?item.Member__r.Phone__c:'N/A',
                planName: item.Membership_Plan__r.Name?item.Membership_Plan__r.Name:'N/A',
                endDate: item.End_Date__c,
                daysLeft: this.calculateDaysLeft(item.End_Date__c)
            }));
            this.filterRows();
            this.errorMessage = undefined;
            this.isLoaded = true;
        } 
        else if (error) {
            this.allRows = [];
            this.rows = [];
            this.errorMessage = 'Unable to load expiring memberships.';
            this.isLoaded = true;
            this.showToast('Error', this.errorMessage, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

    calculateDaysLeft(endDate) {
        if (!endDate) {
            return 'N/A';
        }
        const [year, month, day] = endDate.split('-');
        const expiry = Date.UTC(
            Number(year),
            Number(month) - 1,
            Number(day)
        );

        const today = new Date();
        const todayUTC = Date.UTC(
            today.getFullYear(),
            today.getMonth(),
            today.getDate()
        );
        const days = Math.round((expiry - todayUTC)/(1000 * 60 * 60 * 24));
        if (days === 0) {
            return 'Expires today';
        }
        if (days === 1) {
            return '1 Day left';
        }
        return `${days} Days left`;
    }

    handleSearch(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filterRows();
    }

    filterRows() {
        this.rows = this.allRows.filter(item =>
            item.memberName.toLowerCase().includes(this.searchKey)
        );
    }

    handleRowAction(event) {
        const memberId = event.detail.row.memberId;
        if (!memberId) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: memberId,
                objectApiName: 'Member__c',
                actionName: 'view'
            }
        });
    }

    get hasRows() {
        return this.rows.length > 0;
    }

    get showEmpty() {
        return this.isLoaded && !this.errorMessage && this.rows.length === 0;
    }

    get emptyMessage() {
        return this.searchKey ? 'No matching member found.' : 'No memberships expiring in the next 7 days.';
    }
}