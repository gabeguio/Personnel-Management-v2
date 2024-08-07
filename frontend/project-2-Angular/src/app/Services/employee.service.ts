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

}
