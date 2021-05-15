import 'package:flutter/material.dart';

class WorkExperienceItem extends StatelessWidget {
  const WorkExperienceItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mercado Libre",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Svelte full-stack developer",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "02/02/2020  02/02/2020",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  OutlinedButton(
                    child: Text("Editar"),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 14),
                      primary: Theme.of(context).primaryColor, // background
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    child: Text("Eliminar"),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 14),
                      primary: Theme.of(context).errorColor, // background
                      side: BorderSide(color: Theme.of(context).errorColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
