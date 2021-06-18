import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';
import './aes.dart';
import './new_message.dart';
import 'package:crypto/crypto.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;

              return ListView.builder(
                  physics:
                      ScrollPhysics(parent: RangeMaintainingScrollPhysics()),
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    var bytes = utf8.encode(decryptAESCryptoJS(
                        chatDocs[index]['text'],
                        "Mysecretpassword@131")); // data being hashed

                    var digest = sha256.convert(bytes);
                    var decrypt = decryptAESCryptoJS(
                        chatDocs[index]['text'], "Mysecretpassword@131");
                    return MessageBubble(
                      digest.toString() == chatDocs[index]['hash']
                          ? decrypt.toString()
                          : "Message Broken",
                      chatDocs[index]['username'],
                      chatDocs[index]['userImage'],
                      chatDocs[index]['userId'] == futureSnapshot.data.uid,
                      ValueKey(chatDocs[index].documentID),
                    );
                  });
            },
          );
        });
  }
}
