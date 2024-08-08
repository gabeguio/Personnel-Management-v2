import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Employee } from '../Models/employee';

@Injectable()
export class AccountService {

  constructor(private http: HttpClient) { }

  url: String = 'http://localhost:3000/api/';
  
  getAllAccounts() {
    return this.http.get(this.url + 'accounts', { observe: 'response' });
  }

  createAccount(account: any) {
    return this.http.post(this.url + 'accounts', account, { observe: 'response' });
  }

  updateAccount(account: any) {
    return this.http.put(this.url + 'accounts/' + account.id, account, { observe: 'response' });
  }

  deleteAccount(id: string) {
    return this.http.delete(this.url + 'accounts/' + id, { observe: 'response' });
  }

}
