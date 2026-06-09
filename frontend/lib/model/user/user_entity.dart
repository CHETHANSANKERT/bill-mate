// import 'dart:convert';
//
// /// To store user's data
// class UserEntity {
//   UserEntity(
//       {this.id,
//         this.updationDate,
//         this.creationDate,
//         this.departmentId,
//         this.fname,
//         this.mname,
//         this.lname,
//         this.image,
//         this.empId,
//         this.userName,
//         this.email,
//         this.type,
//         this.phone,
//         this.roleId,
//         this.leaderId,
//         this.departmentChiefId,
//         this.createdBy,
//         this.mode,
//         this.schoolId,
//         this.contentProviderId,
//         this.parentChildren,
//         this.divId,
//         this.sbjId,
//         this.sbjDivId,
//         this.stdId,
//         this.iV,
//         this.lastLoggedIn,
//         this.termsAcceptedOn});
//
//   UserEntity.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     updationDate = json['updationDate'];
//     creationDate = json['creationDate'];
//     departmentId = json['departmentId'];
//     fname = json['fname'];
//     mname = json['mname'];
//     lname = json['lname'];
//     image = json['image'];
//     empId = json['empId'];
//     userName = json['userName'];
//     email = json['email'];
//     type = json['type'];
//     phone = json['phone'];
//     // roleId = json['roleId'] != null ? RoleId.fromJson(json['roleId']) : null;
//     roleId = json['roleId'] != null ? RoleId.fromJson(json['roleId']) : null;
//     leaderId = json['leaderId'];
//     departmentChiefId = json['departmentChiefId'];
//     createdBy = json['createdBy'];
//     mode = json['mode'];
//     schoolId = json['schoolId'] !=null?json['schoolId'].cast<String>():[];
//     if (json['contentProviderId'] != null) {
//       contentProviderId = <dynamic>[];
//       json['contentProviderId'].forEach((dynamic v) {
//         contentProviderId?.add(v);
//       });
//     }
//
//     if (json['parentChildren'] != null) {
//       parentChildren = <dynamic>[];
//       json['parentChildren'].forEach((dynamic v) {
//         parentChildren?.add(v);
//       });
//     }
//     if (json['divId'] != null) {
//       divId = <DivId>[];
//       json['divId'].forEach((v) {
//         divId?.add(DivId.fromJson(v));
//       });
//     }
//     if (json['sbjId'] != null) {
//       sbjId = <dynamic>[];
//       json['sbjId'].forEach((dynamic v) {
//         sbjId?.add(v);
//       });
//     }
//     if (json['sbjDivId'] != null) {
//       sbjDivId = <dynamic>[];
//       json['sbjDivId'].forEach((dynamic v) {
//         sbjDivId?.add(v);
//       });
//     }
//     if (json['stdId'] != null) {
//       stdId = <StdId>[];
//       json['stdId'].forEach((v) {
//         stdId?.add(StdId.fromJson(v));
//       });
//     }
//     iV = json['__v'];
//     lastLoggedIn = json['lastLoggedIn'];
//     termsAcceptedOn = json['termsAcceptedOn'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = id;
//     data['updationDate'] = updationDate;
//     data['creationDate'] = creationDate;
//     data['departmentId'] = departmentId;
//     data['fname'] = fname;
//     data['mname'] = mname;
//     data['lname'] = lname;
//     data['image'] = image;
//     data['empId'] = empId;
//     data['userName'] = userName;
//     data['email'] = email;
//     data['type'] = type;
//     data['phone'] = phone;
//     if (roleId != null) {
//       data['roleId'] = roleId?.toJson();
//     }
//     data['leaderId'] = leaderId;
//     data['departmentChiefId'] = departmentChiefId;
//     data['createdBy'] = createdBy;
//     data['mode'] = mode;
//     data['schoolId'] = schoolId;
//     if (contentProviderId != null) {
//       data['contentProviderId'] =
//           contentProviderId?.map((v) => v.toJson()).toList();
//     }
//     if (parentChildren != null) {
//       data['parentChildren'] = parentChildren?.map((v) => v.toJson()).toList();
//     }
//     if (divId != null) {
//       data['divId'] = divId?.map((v) => v.toJson()).toList();
//     }
//     if (sbjId != null) {
//       data['sbjId'] = sbjId?.map((v) => v.toJson()).toList();
//     }
//     if (sbjDivId != null) {
//       data['sbjDivId'] = sbjDivId?.map((v) => v.toJson()).toList();
//     }
//     if (stdId != null) {
//       data['stdId'] = stdId?.map((v) => v.toJson()).toList();
//     }
//     data['__v'] = iV;
//     data['lastLoggedIn'] = lastLoggedIn;
//     data['termsAcceptedOn'] = termsAcceptedOn;
//     return data;
//   }
//
//   String? id;
//   String? updationDate;
//   String? creationDate;
//   String? departmentId;
//   String? fname;
//   String? mname;
//   String? lname;
//   String? image;
//   String? empId;
//   String? userName;
//   String? email;
//   String? type;
//   String? phone;
//   RoleId? roleId;
//   String? leaderId;
//   String? departmentChiefId;
//   String? createdBy;
//   String? mode;
//   List<String>? schoolId;
//   List<dynamic>? contentProviderId;
//   List<dynamic>? parentChildren;
//   List<DivId>? divId;
//   List<dynamic>? sbjId;
//   List<dynamic>? sbjDivId;
//   List<StdId>? stdId;
//   int? iV;
//   String? lastLoggedIn;
//   String? termsAcceptedOn;
//   String? fireBaseToken;
//
//   String get fullName => '${fname ?? ''} ${mname ?? ''} ${lname ?? ''}';
//
//   String get getSchoolId => (schoolId ?? []).isEmpty ? '':(schoolId?.first ?? '');
//
// }
//
// class DivId {
//   DivId({
//     this.id,
//     this.updationDate,
//     this.creationDate,
//     this.divName,
//     this.stdId,
//     this.createdBy,
//     this.v,
//     this.schoolId,
//     this.schCode,
//   });
//
//   factory DivId.fromJson(String str) => DivId.fromMap(json.decode(str));
//
//   factory DivId.fromMap(Map<String, dynamic> json) => DivId(
//     id: json['_id'],
//     updationDate: json['updationDate'] == null
//         ? null
//         : DateTime.parse(json['updationDate']),
//     creationDate: json['creationDate'] == null
//         ? null
//         : DateTime.parse(json['creationDate']),
//     divName: json['divName'],
//     stdId: json['stdId'],
//     createdBy: json['createdBy'],
//     v: json['__v'],
//     schoolId: json['schoolId'],
//     schCode: json['schCode'],
//   );
//
//   final String? id;
//   final DateTime? updationDate;
//   final DateTime? creationDate;
//   final String? divName;
//   final String? stdId;
//   final String? createdBy;
//   final int? v;
//   final String? schoolId;
//   final String? schCode;
//
//   String toJson() => json.encode(toMap());
//
//   Map<String, dynamic> toMap() => <String, dynamic>{
//     '_id': id,
//     'updationDate': updationDate?.toIso8601String(),
//     'creationDate': creationDate?.toIso8601String(),
//     'divName': divName,
//     'stdId': stdId,
//     'createdBy': createdBy,
//     '__v': v,
//     'schoolId': schoolId,
//     'schCode': schCode,
//   };
// }
//
// class RoleId {
//   String? sId;
//   String? updationDate;
//   String? creationDate;
//   String? roleName;
//   bool? fullAccess;
//   String? ctalkAccess;
//   String? createdBy;
//   String? schoolId;
//   int? iV;
//
//   RoleId(
//       {this.sId,
//         this.updationDate,
//         this.creationDate,
//         this.roleName,
//         this.fullAccess,
//         this.ctalkAccess,
//         this.createdBy,
//         this.schoolId,
//         this.iV});
//
//   RoleId.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     updationDate = json['updationDate'];
//     creationDate = json['creationDate'];
//     roleName = json['roleName'];
//     fullAccess = json['fullAccess'];
//     ctalkAccess = json['ctalkAccess'];
//     createdBy = json['createdBy'];
//     schoolId = json['schoolId'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['updationDate'] = updationDate;
//     data['creationDate'] = creationDate;
//     data['roleName'] = roleName;
//     data['fullAccess'] = fullAccess;
//     data['ctalkAccess'] = ctalkAccess;
//     data['createdBy'] = createdBy;
//     data['schoolId'] = schoolId;
//     data['__v'] = iV;
//     return data;
//   }
// }
//
// class StdId {
//   StdId({
//     this.id,
//     this.stdName,
//     this.stdDesc,
//     this.updationDate,
//     this.creationDate,
//     this.createdBy,
//     this.stdSeqNo,
//     this.schoolId,
//     this.schCode,
//   });
//
//   factory StdId.fromJson(String str) => StdId.fromMap(json.decode(str));
//
//   factory StdId.fromMap(Map<String, dynamic> json) => StdId(
//     id: json['_id'],
//     stdName: json['stdName'],
//     stdDesc: json['stdDesc'],
//     updationDate: json['updationDate'] == null
//         ? null
//         : DateTime.parse(json['updationDate']),
//     creationDate: json['creationDate'] == null
//         ? null
//         : DateTime.parse(json['creationDate']),
//     createdBy: json['createdBy'],
//     stdSeqNo: json['stdSeqNo'],
//     schoolId: json['schoolId'],
//     schCode: json['schCode'],
//   );
//
//   final String? id;
//   final String? stdName;
//   final String? stdDesc;
//   final DateTime? updationDate;
//   final DateTime? creationDate;
//   final String? createdBy;
//   final int? stdSeqNo;
//   final String? schoolId;
//   final String? schCode;
//
//   String toJson() => json.encode(toMap());
//
//   Map<String, dynamic> toMap() => <String, dynamic>{
//     '_id': id,
//     'stdName': stdName,
//     'stdDesc': stdDesc,
//     'updationDate': updationDate?.toIso8601String(),
//     'creationDate': creationDate?.toIso8601String(),
//     'createdBy': createdBy,
//     'stdSeqNo': stdSeqNo,
//     'schoolId': schoolId,
//     'schCode': schCode,
//   };
// }
