import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { AuthService } from './auth.service';
import { AccountDetail } from '../Models/accountDetails'; // Import the 'Account' class

@Injectable()
export class AccountService {

  constructor(private http: HttpClient, private authService: AuthService) { }

  url: String = 'http://localhost:3000/';

  private getHeaders() {
    return this.authService.getHeaders();
  }

  getAllAccounts() {
    return this.http.get(this.url + 'api/accounts', { headers: this.getHeaders(), observe: 'response' });
  }

  getAccountById(id: string) {
    return this.http.get(this.url + 'api/accounts/' + id, { headers: this.getHeaders(), observe: 'response' });
  }

  createAccount(account: AccountDetail) {
    return this.http.post(this.url + 'api/accounts', account, { headers: this.getHeaders(), observe: 'response' });
  }

  deleteAccount(id: string) {
    return this.http.delete(this.url + 'api/users/' + id, { headers: this.getHeaders(), observe: 'response' });
  }

}
