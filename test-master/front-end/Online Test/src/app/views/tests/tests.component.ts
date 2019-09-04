import { Component, OnInit, ViewChild } from '@angular/core';
import { Test, TestService } from '../../services/test.service';
import { ModalDirective } from 'ngx-bootstrap';
import * as $ from 'jquery';
import { Subject, SubjectService } from '../../services/subject.service';
import { Test_Type, TestTypeService } from '../../services/test_type.service';
import { Semester, SemesterService } from '../../services/semester.service';
import { PnotifyService } from '../../services/pnotify.service';
import { UserService, User } from '../../services/user.service';
import { Part, PartService } from '../../services/part.service';
import { Test_Detail, TestDetailService, Test_DetailRequest } from '../../services/test-detail.service';



@Component({
  selector: 'app-tests',
  templateUrl: './tests.component.html',
  styleUrls: ['./tests.component.scss']
})
export class TestsComponent implements OnInit {
  subjects: [Subject];
  test_type: [Test_Type];
  test_details_id: Test_Detail[];
  sem: [Semester];
  users: [User];
  tests: [Test];
  test: Test = {} as Test;
  parts: Part[];
  test_detail_request: Test_DetailRequest = {} as Test_DetailRequest;
  test_details: Test_Detail[] = [] as Test_Detail[];
  pnotify = undefined;
  @ViewChild('modal') modal: ModalDirective;
  @ViewChild('modalDelete') modalDelete: ModalDirective;
  @ViewChild('modaldetail') modaldetail: ModalDirective;
  constructor(private testService: TestService, private subjectService: SubjectService, private userService: UserService,
    private test_typeService: TestTypeService, private semService: SemesterService, private pnotifyService: PnotifyService,
    private partService: PartService, private test_detailService: TestDetailService) {
    this.pnotify = pnotifyService.getPNotify();
  }

     
  ngOnInit() {
    this.testService.getAll().subscribe(res => {
      this.tests = res.data;
    });
    this.subjectService.getAll().subscribe(
      res => {
        this.subjects = res.data;
      }
    );
    this.userService.getAll().subscribe(res => {
      this.users = res.data;
    });
    this.test_typeService.getAll().subscribe(
      res => {
        this.test_type = res.data;
      }
    );
    this.semService.getAll().subscribe(
      res => {
        this.sem = res.data;
      }
    );
  }

 
  
  showModal(event = null, id: Number = 0) {
    if (event != null) {
      event.preventDefault();
    }
    if (id > 0) {
      this.testService.get(id).subscribe(res => {
        this.test = res.data;
        if(this.test.tesisactive === true || this.test.tesislocked === true){
          for(let i = 1 ; i <= 13 ; i++){
            var temp = "#field_" + i;
            $(temp).prop("disabled", true);
          }
          $('#lock').show();
        }
        else{
          for(let i = 1 ; i <= 13 ; i++){
            var temp = "#field_" + i;
            $(temp).prop("disabled", false);
          }
          $('#lock').hide();
        }       
        $("#modal_title").html("Sửa bài kiểm tra");
        this.modal.show();
      });
    }
    else {
      this.test = {
        id: 0
      } as Test;
      var date = new Date();
      this.test.tesdate = date;
      for(let i = 1 ; i <= 13 ; i++){
        var temp = "#field_" + i;
        $(temp).prop("disabled", false);
      }
      $('#lock').hide();
      $("#modal_title").html("Thêm bài kiểm tra");
      this.modal.show();
    }
  }

  parseDate(dateString: string): Date {
    if (dateString) {
      return new Date(dateString);
    }
    return null;
  }

  save() {
    if (this.test.id === 0) {
      // check
      for(let i = 1 ; i <= 12 ; i++){
        const temp = '#field_' + i;
        if ($(temp).val() === ''){
          this.modal.hide();
            this.pnotify.error({
              title: 'Thông báo',
              text: 'Thêm môn học thất bại! Vui lòng nhập chính xác'
            });
            return null;
        }
      }
      // add
      this.testService.add(this.test).subscribe(res => {
        if (res.errorCode === 0) {
          this.testService.getAll().subscribe(resList => {
            this.tests = resList.data;
            this.modal.hide();
            this.pnotify.success({
              title: 'Thông báo',
              text: 'Thêm môn học ' + res.data.testitle + ' thành công!'
            });
          });
        }
      });
    }
    else {
      // check
      for(let i = 1 ; i <= 12 ; i++){
        const temp = '#field_' + i;
        if ($(temp).val() === ''){
          this.modal.hide();
            this.pnotify.error({
              title: 'Thông báo',
              text: 'Sửa môn học thất bại! Vui lòng nhập chính xác'
            });
            return null;
        }
      }
      //update
      this.testService.put(this.test).subscribe(res => {
         console.log(res);
        if (res.errorCode === 0) {
          this.testService.getAll().subscribe(resList => {
            this.tests = resList.data;
            this.modal.hide();
            this.pnotify.success({
              title: 'Thông báo',
              text: 'Cập nhật môn học ' + res.data.testitle + ' thành công!'
            });
          });
        }
      });
    }
  }

unlock(){
  for(let i = 1 ; i <= 13 ; i++){
    let temp = "#field_" + i;
    $(temp).prop("disabled", false);
  }
}
  

  delete() {
    let id = $("#id_delete").val();
    // console.log(id);
    this.testService.delete(id).subscribe(res => {
      if (res.errorCode === 0) {
        const deletedItem = this.tests.find(x => x.id == id);
        const index = this.tests.indexOf(deletedItem);
        this.tests.splice(index, 1);
        this.modalDelete.hide();
        this.pnotify.success({
          title: 'Thông báo',
          text: 'Xóa loại bài ' + res.data.testitle + ' thành công!'
        });
      }
      else {
        this.modalDelete.hide();
        this.pnotify.error({
          title: 'Thông báo',
          text: 'Xóa loại bài ' + res.data.testitle + ' thất bại! Vẫn còn môn học con!'
        });
      }
    });
  }

   open_Delete(event, id) {
    if (event != null) {
      event.preventDefault();
    }
    $("#id_delete").val(id);
    var temp = "#testname_" + id;
    $("#delete_message").html("Bạn có chắc chắn muốn xóa loại bài " + $(temp).html() + " không?");
    this.modalDelete.show();
  }
  showDetailModal(event = null, id: number = 0, subid: number) {
    this.parts = [];
    $("#test_id").val(id);
    if (event != null) {
      event.preventDefault();
    }
    this.partService.getAllForId(subid).subscribe(res => {
      this.parts = res.data;
    });
    this.test_detailService.get(id).subscribe(res => {
      this.test_details_id = res.data;
      if (this.test_details_id == null) {
        for (let i = 0; i < this.test_details_id.length; i++) {
          let temp = "#num_ques_" + this.test_details_id[i].tesdid;
          $(temp).val('');
        }
      }
      else {
        for (let i = 0; i < this.test_details_id.length; i++) {
          let temp = "#num_ques_" + this.test_details_id[i].tesdid;
          let temp1 = "#num_id_" + this.test_details_id[i].tesdid;
          $(temp).val(this.test_details_id[i].tesdnO_QUESTION);
          $(temp1).val(this.test_details_id[i].id);
        }
      }
    });
    this.modaldetail.show();
  }
  savedetail() {
    this.test_details = [];
    let id = $("#test_id").val();
    this.testService.get(id).subscribe(res => {
      if (res.data.test_detail_list == null) {
        for (let i = 0; i < this.parts.length; i++) {
          let temp = "#par_id_" + this.parts[i].id;
          let temp1 = "#num_ques_" + this.parts[i].id;
          this.test_details.push({
            id: 0,
            teS_ID: 0,
            tesdid: parseInt($(temp).val().toString()),
            tesdtable: 0,
            tesdnO_QUESTION: parseInt($(temp1).val().toString()),
          } as Test_Detail);
        }
        this.test_detail_request.tes_id = parseInt(id.toString());
        this.test_detail_request.list_test_detail = this.test_details;
        console.log(this.test_detail_request);
        this.test_detailService.add(this.test_detail_request).subscribe(res => {
          console.log(res);
          this.modaldetail.hide();
          this.pnotify.success({
            title: 'Thông báo',
            text: 'Thêm chi tiết bài thi thành công!'
          });
        })
      }
      // else {
      //   this.test_detailService.get(res.data.id).subscribe(res => {
      //     this.test_details = res.data;
      //   });
      // }
    });
  }
}
