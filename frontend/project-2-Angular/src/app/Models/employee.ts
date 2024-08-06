import { Name } from './name';
import { Email } from './email';

export class Employee {

    userName: string;
    name: Name;
    displayName: string;
    userType: string;
    active: boolean;
    password: string;
    emails: Email[];


    constructor(userName: string, name: Name, displayName: string, userType: string, active: boolean, password: string, emails: Email[]) {
        this.userName = userName;
        this.name = name;
        this.displayName = displayName;
        this.userType = userType;
        this.active = active;
        this.password = password;
        this.emails = emails;
    }

}
