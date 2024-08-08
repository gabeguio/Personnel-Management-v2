import { Component, OnInit } from '@angular/core';
import { LazyLoadEvent, MessageService, SelectItem, SortEvent } from 'primeng/api';
import { Table } from 'primeng/table';
import { timeout } from 'rxjs';
import { Email } from 'src/app/Models/email';
import { Employee } from 'src/app/Models/employee';
import { Name } from 'src/app/Models/name';
import { AccountService } from 'src/app/Services/account.service';

import { EmployeeService } from 'src/app/Services/employee.service';

@Component({
    templateUrl: './accounts.component.html',
    providers: [MessageService]
})
export class AccountsComponent implements OnInit {

    accounts: any[] = [];

    users: any[] = [];

    applications: any[] = [];
    
    defaultAccount = {
        "identity":
        {
            "value": "" // This is the IdentityID from IdentityIQ
        },
        "application":
        {
            "value": "" // This is the Application ID (Salesforce in our case). This can be hardcoded if desired because it will be the same for everybody
        },
        "nativeIdentity": "", // This is the Salesforce ID inside of Salesforce itself. Leave it blank because it will be auto generated by Salesforce
        "urn:ietf:params:scim:schemas:sailpoint:1.0:Application:Schema:Salesforce:account":
        {
            "ProfileName": "Standard User", // This should always be "Standard User"
            "Username": "", // This is the username to login into Salesforce. can be edited as desired but it HAS to have an email format
            "LastName": "", // This is a standard last name can me edited as desired
            "FirstName": "", // This is  is a standard First name can me edited as desired
            "CommunityNickname": "", // This is a nickname used inside of Salesforce. Has to be unique otherwise we get an error
            "Alias": "", // I'm not really sure what this is but it has to be unique PLUS it has a max length of 8 characters.
            "Email": "", // Standard email can be edited as desired but it has to have an email format
            "TimeZoneSidKey": "America/Los_Angeles", // This should always be "America/Los_Angeles",
            "LocaleSidKey": "en_US", // This should always be "en_US",
            "EmailEncodingKey": "UTF-8", // This should always be "UTF-8"
            "LanguageLocaleKey": "en_US" // This should always be  "en_US"
        }
    };

    selectedAccounts: any[] = [];

    accountDialog: boolean = false;

    deleteAccountDialog: boolean = false;

    deleteAccountsDialog: boolean = false;
    
    submitted: boolean = false;

    account: any = this.defaultAccount;

    cols: any[];

    loading: boolean = false;

    creatingAccount: boolean;

    constructor(private accountService: AccountService, private employeeService: EmployeeService, private messageService: MessageService) {}

    ngOnInit() {
        this.loading = true;
        this.accountService.getAllAccounts()
        .pipe(timeout(20000)) // 20 seconds timeout
        .subscribe({
            next: (response) => {
                let body: any = response.body;

                console.log(body.Resources);

                body.Resources.forEach((resource: any) => {
                    if (!resource.applicationDisplayName) {
                        resource.applicationDisplayName = resource.application.displayName;
                    }
                });

                this.accounts = body.Resources.filter((resource: any) => resource.active);

                this.cols = [
                    { field: 'displayName', header: 'displayName' },
                    { field: 'id', header: 'id' },
                    { field: 'applicationDisplayName', header: 'applicationDisplayName' },
                    { field: 'active', header: 'active' }
                ];

                this.loading = false;
            },
            error: (err) => {
                this.loading = false;
                this.messageService.add({ severity: 'error', summary: 'Error', detail: err.message, life: 3000 });
            }
        });
        this.employeeService.getAllEmployees()
        .pipe(timeout(20000)) // 20 seconds timeout
        .subscribe({
            next: (response) => {
                let body: any = response.body;

                body.Resources.forEach((resource: any) => {
                    this.users.push({ label: resource.displayName.slice(0, 30).toString(), value: resource.id.toString() });
                });
            },
            error: (err) => {
                this.loading = false;
                this.messageService.add({ severity: 'error', summary: 'Error', detail: err.message, life: 3000 });
            }
        });

        this.applications = [ { label: 'Salesforce', value: 'ac12000290eb1baf8190f0a73ef80926' } ];
    }

    customSort(event: any) {
        event.data.sort((data1: any, data2: any) => {
            let value1 = this.resolveFieldData(data1, event.field);
            let value2 = this.resolveFieldData(data2, event.field);
            let result = null;

            if (typeof value1 === 'object' && value1 !== null) {
                value1 = value1.displayName;
            }

            if (typeof value2 === 'object' && value2 !== null) {
                value2 = value2.displayName;
            }
    
            if (value1 == null && value2 != null)
                result = -1;
            else if (value1 != null && value2 == null)
                result = 1;
            else if (value1 == null && value2 == null)
                result = 0;
            else if (typeof value1 === 'string' && typeof value2 === 'string')
                result = value1.localeCompare(value2);
            else
                result = (value1 < value2) ? -1 : (value1 > value2) ? 1 : 0;
    
            return (event.order * result);
        });
    }

    resolveFieldData(data: any, field: string): any {
        if (data && field) {
            let fields = field.split('.');
            let value = data;
            for (let i = 0; i < fields.length; i++) {
                if (value == null) {
                    return null;
                }
                value = value[fields[i]];
            }
            return value;
        } else {
            return null;
        }
    }

    openNew() {
        this.account = this.defaultAccount;
        this.submitted = false;
        this.accountDialog = true;
        this.creatingAccount = true;
    }

    deleteSelectedAccounts() {
        this.deleteAccountsDialog = true;
    }

    deleteAccount(account: any) {
        this.deleteAccountDialog = true;
        this.account = { ...account };
    }

    confirmDeleteSelected() {
        this.deleteAccountsDialog = false;
        this.accounts = this.accounts.filter(val => !this.selectedAccounts.includes(val));
        for (let i = 0; i < this.selectedAccounts.length; i++) {
            this.accountService.deleteAccount(this.selectedAccounts[i].id);
        }
        this.messageService.add({ severity: 'success', summary: 'Successful', detail: 'Accounts Deleted', life: 3000 });
        this.selectedAccounts = [];
    }

    confirmDelete() {
        this.deleteAccountDialog = false;
        this.accountService.deleteAccount(this.account.id)
        .pipe(timeout(5000)) // 5 seconds timeout
        .subscribe({
            next: (response) => {
                console.log(response);
                this.accounts = this.accounts.filter(val => val.id !== this.account.id);
                this.messageService.add({ severity: 'success', summary: 'Successful', detail: 'Account Deleted', life: 3000 });
            },
            error: (err) => {
                this.messageService.add({ severity: 'error', summary: 'Error', detail: err.message, life: 3000 });
            }
        });
        this.account = this.defaultAccount;
    }

    hideDialog() {
        this.accountDialog = false;
        this.submitted = false;
        this.creatingAccount = false;
    }

    saveAccount() {
        this.submitted = true;
    
        if (this.account.identity.value?.trim() && this.account.application.value?.trim()) {
            console.log(this.account);
            this.accountService.createAccount(this.account)
                .pipe(timeout(5000)) // 5 seconds timeout
                .subscribe({
                    next: (response) => {
                        console.log(response);
                        this.account.id = response.body['id'];
                        this.accounts = [ ...this.accounts, this.account ];
                        this.messageService.add({ severity: 'success', summary: 'Successful', detail: 'Account Created', life: 3000 });
                    },
                    error: (err) => {
                        this.messageService.add({ severity: 'error', summary: 'Error', detail: "Unable to create account, check fields and try again", life: 3000 });
                    }
                });

        this.accountDialog = false;
        this.creatingAccount = false;
        }
    }

    findIndexById(id: string): number {
        let index = -1;
        for (let i = 0; i < this.accounts.length; i++) {
            if (this.accounts[i].id === id) {
                index = i;
                break;
            }
        }

        return index;
    }

    onGlobalFilter(table: Table, event: Event) {
        table.filterGlobal((event.target as HTMLInputElement).value, 'contains');
    }
    
}
