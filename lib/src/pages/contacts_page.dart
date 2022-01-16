import 'package:contacts/src/cubit/contact_cubit/contact_cubit.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {


  @override
  void initState() {
    getContacts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {

      if(state is ContactLoading){
       return Center(child: CircularProgressIndicator());
      }

      else if(state is ContactLoadError){
       return Center(child: Text(state.errorMessage));


      }else if(state is ContactLoaded){
        List<Contact> contacts =state.contacts;

        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            Contact contact = contacts[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: Colors.blue,
                ),
                child: Center(child: Text(contact.initials())),
              ),
              title: Text(contact.displayName??"",style: TextStyle(color: Colors.red),),

              trailing: IconButton(
                onPressed:(){
                  deleteContact(contact);
                },
                icon: Icon(Icons.delete),
              ),

            );
          },

        );

      }
      else{
        return Container();
      }


  },
),

    );
  }

  void getContacts() { 
      BlocProvider.of<ContactCubit>(context).getContacts();
      
  }

  void deleteContact(Contact contact) {
    BlocProvider.of<ContactCubit>(context).deleteContact(contact);
  }


}
