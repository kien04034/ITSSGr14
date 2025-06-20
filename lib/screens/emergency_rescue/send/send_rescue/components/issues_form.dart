import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/helper/keyboard.dart';
import 'package:flutter_application_1/providers/issue_provider.dart';
import 'package:flutter_application_1/repositories/issue_repository.dart';
import 'package:flutter_application_1/screens/emergency_rescue/issue_details/issue_details_screen.dart';
import 'package:flutter_application_1/screens/emergency_rescue/send/wait_websocket/wait_websocket_screen.dart';
import 'package:flutter_application_1/screens/emergency_rescue/user_info/user_info_screen.dart';

import '/components/custom_surfix_icon.dart';
import '/components/default_button.dart';
import '/config/enums.dart';
import '/config/size_config.dart';
import '/helper/util.dart';
import '/models/issue.dart';
import '/screens/place/repair_place/repair_place_manage_add_edit/components/location_input.dart';

class IssuesForm extends StatefulWidget {
  Issue? issue; //Không cần truyền giá trị vào, vì chỉ create, ko update

  IssuesForm({Key? key}) : super(key: key);

  @override
  _IssuesFormState createState() => _IssuesFormState();
}

class _IssuesFormState extends State<IssuesForm> {
  Issue _issue = Issue(); //khởi tạo giá trị ban đầu, cập nhật ở initState()
  final _formKey = GlobalKey<FormState>();

  List<IssueCategory> issueCategories = IssueCategory.values;

  //IssueCategory? issueCategorySelected;

  @override
  void initState() {
    //Lấy giá trị từ widget.issue, nếu nó null thì khởi tạo :
    _issue = widget.issue ?? Issue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //widget.issue ??= Issue(); //Khởi tạo nếu null

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildCategoryDropdownFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLocationInput(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Yêu cầu hỗ trợ",
            press: () => _submitForm(),
          ),
        ],
      ),
    );
  }

  DropdownButtonFormField buildCategoryDropdownFormField() {
    return DropdownButtonFormField(
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: issueCategories
          .map<DropdownMenuItem<IssueCategory>>((IssueCategory value) {
        return DropdownMenuItem<IssueCategory>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      //value: widget.issue!.category,
      onSaved: (newValue) => _issue.category = newValue,
      onChanged: (newValue) {
        setState(() {
          _issue.category = newValue!;
        });
      },
      validator: (value) {
        if (value == null) {
          return "Vui lòng chọn danh mục của bạn";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Danh Mục",
        hintText: "-- Chọn Danh Mục --",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 20, left: 42, right: 22),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      initialValue: _issue.phone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => _issue.phone = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Vui lòng nhập số điện thoại của bạn";
        }
        if (value.length < 10) {
          return "Kích thước phải lớn hơn 10";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Điện thoại",
        hintText: "Nhập số điện thoại của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      initialValue: _issue.address,
      onSaved: (newValue) => _issue.address = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Vui lòng nhập địa chỉ của bạn";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mô tả địa chỉ hiện tại",
        hintText: "Nhập địa chỉ của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      initialValue: _issue.description,
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 5,
      onSaved: (newValue) => _issue.description = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Vui lòng nhập mô tả";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mô tả sự số",
        hintText: "Nhập mô tả chi tiết",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Chat bubble Icon.svg"),
      ),
    );
  }

  Widget buildLocationInput() {
    return LocationInput(
      onSelectPlace: (latLngSelected) {
        _issue.latitude = latLngSelected.latitude;
        _issue.longitude = latLngSelected.longitude;
      },
      latLngInitial: _issue.latitude != null && _issue.longitude != null
          ? LatLng(_issue.latitude!, _issue.longitude!)
          : null,
    );
  }

  Future<void> _submitForm() async {
    KeyboardUtil.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_issue.latitude == null && _issue.longitude == null) {
      await Util.showDialogNotification(
          context: context,
          title: "Thiếu thông tin",
          content: "Vui lòng cập nhật vị trí bản đồ");

      return;
    }

    _formKey.currentState!.save();

    try {
      // 01. Tạo & Gửi yêu cầu hỗ trợ (issue)
      Issue itemResponse =
          await Provider.of<IssueProvider>(context, listen: false).send(_issue);

      await Util.showDialogNotification(
          context: context,
          title: "Thành Công",
          content: "Đã gửi yêu cầu cứu hộ khẩn cấp");

      // 02. Chờ WebSocket phản hồi: đã có partner nhận hay chưa
      Navigator.pushNamed(
        context,
        WaitWebSocketScreen.routeName,
        arguments: WaitWebSocketArguments(
          message: "Chỉ một lúc thôi...\nHệ thống đang tìm người hỗ trợ bạn.",
          destination:
              '/topic/issue/memberWaitPartner/' + itemResponse.id.toString(),
          callback: (stompFrame) =>
              _callbackWebSocket(stompFrame, itemResponse.id!),
          onCancel: () => _canceledByMember(context, itemResponse),
        ),
      );
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }

  Future<void> _callbackWebSocket(stompFrame, int issueId) async {
    if (stompFrame.body != null) {
      Map<String, dynamic> response = json.decode(stompFrame.body!);
      IssueStatus issueStatus = IssueStatus.values.firstWhere(
        (element) =>
            element.toString() ==
            "IssueStatus." + response['data']['issueStatus'],
      );

      if (issueStatus == IssueStatus.waitMemberConfirm) {
        Issue issueReload = await IssueRepository.findById(issueId);

        Navigator.pushReplacementNamed(
          context,
          UserInfoScreen.routeName,
          arguments: UserInfoArguments(
            user: issueReload.userPartner!,
            onConfirm: () => _memberConfirmPartner(context, issueReload),
            onCancel: () => _canceledByMember(context, issueReload),
          ),
        );
        //Navigator.pop(context);
      }
    }
  }

  Future<void> _memberConfirmPartner(context, Issue issue) async {
    try {
      String message = await Provider.of<IssueProvider>(context, listen: false)
          .memberConfirmPartner(issue);

      await Util.showDialogNotification(
        context: context,
        title: "Thành công",
        content: message,
      );

      Issue issueReload = await IssueRepository.findById(issue.id!);
      Navigator.pushReplacementNamed(
        context,
        IssueDetailsScreen.routeName,
        arguments: IssueDetailsArguments(issue: issueReload),
      );
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }

  Future<bool> _canceledByMember(context, Issue issue) async {
    try {
      String message = await Provider.of<IssueProvider>(context, listen: false)
          .canceledByMember(issue);

      await Util.showDialogNotification(
        context: context,
        title: "Hủy thành công",
        content: message,
      );

      return true;
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }

    return false;
  }
}
