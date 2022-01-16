import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  Future<void>getContacts() async{
    await Future.delayed(Duration(seconds: 2));
    emit(ContactLoading());
    PermissionStatus status = await Permission.contacts.request();
    if(status.isGranted){
      List<Contact> contacts= await loadContacts();
      emit(ContactLoaded(contacts));
    }
    else{
      emit(ContactLoadError("Permission Denied"));
    }
  }

  Future<List<Contact>>loadContacts() async{
    List<Contact> contactTemp = await ContactsService.getContacts();
   return contactTemp;

  }
  Future<void> deleteContact(Contact contact) async
  {
    emit(ContactLoading());
    await Future.delayed(Duration(seconds: 2));
    await ContactsService.deleteContact(contact);
    List<Contact> contactTemp = await loadContacts();
    emit(ContactLoaded(contactTemp));

  }
}
