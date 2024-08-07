console.log("routing1");
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { EmployeesComponent } from './employees.component';
console.log("routing");

@NgModule({
	imports: [RouterModule.forChild([
		{ path: '', component: EmployeesComponent }
	])],
	exports: [RouterModule]
})
export class EmployeesRoutingModule { }
