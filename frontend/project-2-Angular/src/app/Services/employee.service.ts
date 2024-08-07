import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Employee } from '../Models/employee';

@Injectable()
export class EmployeeService {

  constructor(private http: HttpClient) { }

  url: String = 'http://localhost:3000/';
  

  // a GET request for all Employees
  getAllEmployees() {
    return this.http.get(this.url + 'api/users', { observe: 'response' });
  }

  createEmployee(employee: Employee) {
    return this.http.post(this.url + 'api/users', employee, { observe: 'response' });
  }

  updateEmployee(employee: Employee) {
    return this.http.put(this.url + 'api/users/' + employee.id, employee, { observe: 'response' });
  }

  deleteEmployee(id: string) {
    return this.http.delete(this.url + 'api/users/' + id, { observe: 'response' });
  }

}
