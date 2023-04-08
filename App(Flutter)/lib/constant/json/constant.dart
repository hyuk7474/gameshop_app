import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List itemsTab = [
  {"icon": Icons.home, "size": 30.0},
  {"icon": Icons.search, "size": 30.0},
  {"icon": Icons.menu, "size": 30.0},
  {"icon": Icons.person, "size": 30.0},
  {"icon": Icons.shopping_basket, "size": 30.0},
];

class Category {
  final String? title, image;
  final int? id;
  final Color? color;
  Category({
    this.id,
    this.image,
    this.title,
    this.color,
  });
}
List<Category> categories2 = [
  Category(
    id: 1,
    title: "Action",
    color: Colors.white,
    image: "assets/images/raster/ori blind forest/ori-1.jpg",
  ),
  Category(
    id: 2,
    title: "Adventure",
    color: Colors.white,
    image: "assets/images/raster/ori blind forest/ori-2.jpg",
  ),
  Category(
    id: 3,
    title: "Puzzle",
    color: Colors.white,
    image: "assets/images/raster/ori blind forest/ori-3.jpg",
  ),
  Category(
    id: 4,
    title: "Role",
    color: Colors.white,
    image: "assets/images/raster/ori blind forest/ori-4.jpg",
  ),
  Category(
    id: 5,
    title: "Shooting",
    color: Colors.white,
    image: "assets/images/raster/rayman legends/rl-1.jpg",
  ),
  Category(
    id: 6,
    title: "Simulation",
    color: Colors.white,
    image: "assets/images/raster/rayman legends/rl-2.jpg",
  ),
  Category(
    id: 7,
    title: "Rhythm",
    color: Colors.white,
    image: "assets/images/raster/rayman legends/rl-3.jpg",
  ),
  Category(
    id: 8,
    title: "Limited",
    color: Colors.white,
    image: "assets/images/raster/rayman legends/rl-4.jpg",
  ),
];

const List<Map<String, Object>> rdr2 = [
  {
    'title': 'rdr2',
    'price': '30',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2%2Frdr2-1.jpg?alt=media&token=89903511-479e-4574-807d-7f90f0bec6c2',
  },
  {
    'title': 'rdr2',
    'price': '35',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2%2Frdr2-2.jpg?alt=media&token=45c76e46-bea2-4cc8-9611-f48e7d7d5da0',
  },
  {
    'title': 'rdr2',
    'price': '25',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2%2Frdr2-3.jpg?alt=media&token=0a910671-e9ae-4db7-9a11-1e6018d0054a',
  },
  {
    'title': 'rdr2',
    'price': '30',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2%2Frdr2-4.jpg?alt=media&token=6baac886-aa92-4eb2-98ad-245f138b262e',
  },
  {
    'title': 'rdr2',
    'price': '20',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2%2Frdr2-5.jpg?alt=media&token=7507db8c-f710-4acf-9e6f-776e14472d6c'
  }
];

const List<Map<String, Object>> populargame = [
  {
    'title': 'Forza Horizon 4',
    'price': '45000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Ffh4%2Ffh4.jpg?alt=media&token=05be947e-a93a-4493-84d0-38487b561fb1',
  },
  {
    'title': 'Grand Theft Auto V',
    'price': '30000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5.jpg?alt=media&token=02099b3c-73a8-4122-9774-c3824ed6e342',
  },
  {
    'title': 'Nier Automata',
    'price': '40000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fnierauto%2Fniera.jpg?alt=media&token=c7a7daca-578c-453f-be61-f48a9246c473',
  },
  {
    'title': 'Red Dead Redemption II',
    'price': '50000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2.jpg?alt=media&token=aeffe752-8710-459c-a34b-63b05e0e201e',
  },
  {
    'title': 'Cyberpunk 2077',
    'price': '60000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcyber2077%2Fcf.jpg?alt=media&token=e0616079-23cf-46e4-82a7-badadeacae1a',
  },
];

const List<Map<String, Object>> salegame = [
  {
    'title': 'Battlefield 2042',
    'price': '50000',
    'sprice' : '35000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcategory%2Fbf.jpg?alt=media&token=61611796-a295-47b7-a610-3c999282a67d',
  },
  {
    'title': 'Forza Horizon 5',
    'price': '60000',
    'sprice' : '40000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcategory%2Fforza5.jpg?alt=media&token=134daeb8-915f-4ed3-b824-211bbe10f249',
  },
  {
    'title': 'Last of Us part II',
    'price': '40000',
    'sprice' : '30000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Flou2%2Flou.jpg?alt=media&token=77bc31a9-c0cb-4c44-8c8a-29e2cffc4f69',
  },
  {
    'title': 'Forza Horizon 4',
    'price': '45000',
    'sprice': '25000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Ffh4%2Ffh4.jpg?alt=media&token=05be947e-a93a-4493-84d0-38487b561fb1',
  },
  {
    'title': 'Battlefield 2042',
    'price': '50000',
    'sprice': '35000',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcategory%2Fbf.jpg?alt=media&token=61611796-a295-47b7-a610-3c999282a67d',
  },
];
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------

const List<Map<String, Object>> recently = [
  {
    'title': 'Ori',
    'price': '30',
    'imgUrl':
        'https://cdn.akamai.steamstatic.com/steam/apps/387290/capsule_616x353.jpg?t=1612858122',
  },
  {
    'title': 'Ori',
    'price': '35',
    'imgUrl':
        'https://cdn.cloudflare.steamstatic.com/steam/apps/261570/ss_c617379b9d195eed0342f3ecf86898513e702b96.1920x1080.jpg?t=1590605540',
  },
  {
    'title': 'Ori',
    'price': '25',
    'imgUrl':
        'https://cdn.cloudflare.steamstatic.com/steam/apps/261570/ss_3b56520665b8fe3bba8df7e4cd239273c7156ab1.1920x1080.jpg?t=1590605540',
  },
  {
    'title': 'Ori',
    'price': '30',
    'imgUrl':
        'https://s.yimg.com/uu/api/res/1.2/ydY9gSPsYD4L2YVHD5XynA--~B/Zmk9ZmlsbDtoPTM4MDt3PTY3NTthcHBpZD15dGFjaHlvbg--/https://s.yimg.com/uu/api/res/1.2/y1UUfHzNLOvclTJxcQvumw--~B/aD0xMDgwO3c9MTkyMDthcHBpZD15dGFjaHlvbg--/https://o.aolcdn.com/hss/storage/midas/ddeb98a6b51b4fd647a763b12bf63933/203717079/oriscreenforlornd-jpg1.jpg.cf.jpg',
  },
  {
    'title': 'Ori',
    'price': '20',
    'imgUrl':
        'https://cdn.cloudflare.steamstatic.com/steam/apps/261570/ss_2d8a25f1cd27d054022ddc1ec7b37cdde55a96c8.1920x1080.jpg?t=1590605540'
  }
];

const List<String> slider = [
  'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcyber2077%2Fcf.jpg?alt=media&token=e0616079-23cf-46e4-82a7-badadeacae1a',
  'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcategory%2Fforza5.jpg?alt=media&token=134daeb8-915f-4ed3-b824-211bbe10f249',
  'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fcategory%2Fbf.jpg?alt=media&token=61611796-a295-47b7-a610-3c999282a67d',
  'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Facval%2Facv.jpg?alt=media&token=b76b79b3-7ed0-4fbf-b138-1eee8d974d1c'
];

const List cartList = [
  {
    "img":
        "https://images.unsplash.com/photo-1495385794356-15371f348c31?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
    "name": "Snoopy T-shirt",
    "ref": "04559812",
    "price": "\$40",
    "size": "S"
  },
  {
    "img":
        "https://images.unsplash.com/photo-1545291730-faff8ca1d4b0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
    "name": "American",
    "ref": "04459811",
    "price": "\$30",
    "size": "M"
  },
];

List storeList = [
  {
    "img":
        "assets/images/raster/ori blind forest/ori-1.jpg",
    "name": "Ori and the Blind Forest",
    "open": 1
  },
  {
    "img":
        "assets/images/raster/ori blind forest/ori-2.jpg",
    "name": "Ori and the Blind Forest",
    "open": 0
  },
  {
    "img":
        "assets/images/raster/ori blind forest/ori-3.jpg",
    "name": "Ori and the Blind Forest",
    "open": 1
  },
];