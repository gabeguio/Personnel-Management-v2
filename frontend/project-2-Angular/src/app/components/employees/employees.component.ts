console.log("component1");
import { Component, OnInit } from '@angular/core';
import { MessageService, SelectItem } from 'primeng/api';
import { Table } from 'primeng/table';
import { Employee } from 'src/app/Models/employee';

import { EmployeeService } from 'src/app/Services/employee.service';
console.log("component");

@Component({
    templateUrl: './employees.component.html',
    providers: [MessageService]
})
export class EmployeesComponent implements OnInit {

    employees: any[] = [];

    selectedEmployees: Employee[] = [];

    employeeDialog: boolean = false;

    deleteEmployeeDialog: boolean = false;

    deleteEmployeesDialog: boolean = false;
    
    submitted: boolean = false;

    employee: any = {};

    cols: any[];

    sortOptions: SelectItem[] = [];

    sortOrder: number = 0;

    sortField: string = 'displayName';

    loading: boolean = false;

    constructor(private employeeService: EmployeeService, private messageService: MessageService) { }

    ngOnInit() {
        this.loading = true;
        this.employeeService.getAllEmployees()
        .subscribe(response => {
          let body: any = response.body;

          console.log(body.Resources);
          this.employees = body.Resources;

          this.cols = [
            { field: 'displayName', header: 'Display Name' },
            { field: 'emails[0].value', header: 'Email' },
            { field: 'displayName', header: 'Manager' }
          ];

          this.loading = false;
        });

        this.sortOptions = [
            { label: 'Name A-Z', value: 'displayName' },
            { label: 'Name Z-A', value: '!displayName' }
        ];
    }

    openNew() {
        this.employee = {};
        this.submitted = false;
        this.employeeDialog = true;
    }

    deleteSelectedEmployees() {
        this.deleteEmployeesDialog = true;
    }

    editEmployee(employee: any) {
        this.employee = { ...employee };
        this.employeeDialog = true;
    }

    deleteEmployee(employee: any) {
        this.deleteEmployeeDialog = true;
        this.employee = { ...employee };
    }

    confirmDeleteSelected() {
        this.deleteEmployeesDialog = false;
        this.employees = this.employees.filter(val => !this.selectedEmployees.includes(val));
        this.messageService.add({ severity: 'success', summary: 'Successful', detail: 'Employees Deleted', life: 3000 });
        this.selectedEmployees = [];
    }

    confirmDelete() {
        this.deleteEmployeeDialog = false;
        this.employees = this.employees.filter(val => val.display !== this.employee.id);
        this.messageService.add({ severity: 'success', summary: 'Successful', detail: 'Employee Deleted', life: 3000 });
        this.employee = {};
    }

    hideDialog() {
        this.employeeDialog = false;
        this.submitted = false;
    }

    saveEmployee() {
        this.submitted = true;
    }

    findIndexById(id: string): number {
        let index = -1;
        for (let i = 0; i < this.employees.length; i++) {
            if (this.employees[i].id === id) {
                index = i;
                break;
            }
        }

        return index;
    }

    createId(): string {
        let id = '';
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        for (let i = 0; i < 5; i++) {
            id += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return id;
    }

    onGlobalFilter(table: Table, event: Event) {
        table.filterGlobal((event.target as HTMLInputElement).value, 'contains');
    }
    
}
