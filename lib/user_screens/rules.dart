import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFED467),
        title: Text('Pravila za pridobivanje točk'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildRuleItem('Vsak končan trening', '10 XP'),
            _buildRuleItem('Vsak liter popite vode', '5 XP'),
            _buildRuleItem(
                'Vsaka dodatna aktivnost izven rednega treninga', '15 XP'),
            _buildRuleItem('Vsaka vožnja s kolesom nad 5 kilometrov', '20 XP'),
            _buildRuleItem(
                'Če redno uporabljate funkcijo sledenja kalorij, točke dobite za vsak teden',
                '10 XP'),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String rule, String xp) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rule,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            xp,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
