# MIPTGRAM Social Network

This repository contains the source code for the cross-platform social network MIPTGRAM created by MIPT students for MIPT students. The project was developed as the final project in Computer Technology for the 4th semester.

<img src="https://sun9-34.userapi.com/impg/Whg5fUIxnHlEXY3ejbC9ewgDaEMAROugw3yJaw/G7GZCV__R6U.jpg?size=727x471&quality=96&sign=fc79adb5cf69239d3b453c63ac912b83&type=album" alt="miptgram" width="200"/>


## Table of Contents

- [Team](#team)
- [Purpose](#purpose)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Project Overview](#project-overview)
- [Database](#database)
- [Asynchrony and Multithreading](#asynchrony-and-multithreading)
- [Menus and Applications](#menus-and-applications)
- [Installation](#installation)
- [License](#license)
- [Future Plans](#future-plans)

## Team
- Amadei Vorontsov
- Yaroslav Nikolaev
- Ivan Chevychelov
- Lena Zemskova.

## Purpose 
The purpose of the MIPTgram project is to provide a social network platform for students of the Moscow Institute of Physics and Technology (MIPT) that is cross-platform and accessible on any device. It aims to connect students and provide them with a variety of features such as a schedule, newsfeed, and a graph builder for labs. By creating a social network tailored to the needs of MIPT students, the project team hopes to enhance communication and collaboration among students and contribute to their academic success. The project also serves as a final project for the 4th semester of the Computer Technology course at MIPT.

## Tech Stack
- Flutter Framework
- Dart language
- Rive
- Linux administration
- Python for server's apps (Flask, matplotlib, numpy)
- PostgreSQL
- NoSQL
- C/C++
- Swift
- Kotlin
- Object Oriented Programming
- Parallel programming usinc acync/await template, Future and Stream objects; using multiprocessing on the server side of the application

## Features
- Chat between students and professors (in future)
- Subject schedule for students 
- Phystech.Conversations, a platform for anonymous posts
- General physics lab handler, which includes laboratory work results, schedules, and materials (in future)

## Project Overview

MIPTGRAM is a social network for MIPT students that can be run on any device and in a web browser. The programming language chosen for the project is Dart object-oriented language using Flutter framework, which is separately compiled into C++, HTML, Kotlin, or Swift depending on the platform. The entire server-side is written in Python. A separate Rive application was used to create animations. 
At the moment, the application has registration and account authorization, a schedule that is updated for each student, a Phystech.Confessions newsfeed, and a graph builder for labs.

## Database

PostgreSQL is used as a database management system, which has tables because it is a relational database. The database is hosted on a computer with an external irstpin and can be connected to from anywhere. 

The PostgreSQL database has several tables, including:
- `groups`: contains the full group name and group id

![](https://sun9-79.userapi.com/impg/RAdjGAO6ymnpR-okPcIUWT-tDmhBqptYYruBsQ/rqTcLrKP7b8.jpg?size=296x117&quality=96&sign=b57bb6deb703039450b50275907d5923&type=album)

- `users`: contains user id, first name, last name, group id, password, mail. Instead of passwords, it stores an MD5 hash of 'password' + 'kisy lubish'. In PostgreSQL, this hash is simply calculated using the `md5(concat(password, 'kisy lubish'))` function.

![](https://sun9-73.userapi.com/impg/kcOOUpA2YaLTwBQFFz5AXxO6QS31mfr_1dxxYA/LW0eTiBl94c.jpg?size=855x153&quality=96&sign=61def97c14340b502eee6549fcca2a75&type=album)

- `pairs`: contains the pair's id and the time of the pair

![](https://sun9-52.userapi.com/impg/XNreuR6XGa-D5HoImX1lFfZHustHAlJJO0ZFPA/FfbMzjgHB-U.jpg?size=284x187&quality=96&sign=235f2fe15bdba0dcc3fb438a7e6e109d&type=album)

- `weekdays`: table with days of the week

![](https://sun9-71.userapi.com/impg/hcvKCUXqV0gG67ly0qG8TOfBN1B43ljKEgdf9w/h0gGFtN6w5E.jpg?size=301x193&quality=96&sign=1be81fdc17cbaec8f016441e4fd954b1&type=album)

- `subjects`: table with all kinds of subjects

![](https://sun9-58.userapi.com/impg/x3ZaDS9hPmdU0FNkgEHcT9487IPQrHEyczRmQA/1e8tgUD_mrg.jpg?size=339x158&quality=96&sign=7a30b90bba00d313dc43d90f43d9497d&type=album)

- `schedule`: table with the schedule, where each column are the IDs, they can be combined tables and get the texts all.

![](https://sun9-10.userapi.com/impg/WlWITBjl8dVsZQAoy0si4-eJsILJiZCCDSm7bQ/VgnrpNxDIzM.jpg?size=401x243&quality=96&sign=ebb01301aa6f4491e9c29b7414ac46a7&type=album)

- `posts`: similar table with posts.

In addition, there is also a local database for each platform. This is a NoSQL database that is used to save the information and the user, so as not to ask him to log in every time, and old posts so as not to download them every time.

## Asynchrony and Multithreading

On the client-side, the `async/await` template is used, through which all requests to the database are done in parallel. For example, when the login and password are checked, in parallel, information is sent to the server, and the animation download is displayed. When updating the schedule or writing a new post, access to the database is done in parallel with the rest of the application, so the application does not hang up, and the user can use it while sending data.

On the server-side, a Python program with Flask, NumPy, and Matplotlib libraries is used to draw graphs. The main process is the parent process, which sits listening to incoming requests. For each request, it runs a separate process that sends a picture to the parent process. This was done to handle a large number of requests and to avoid memory leaks that are allowed by the Matplotlib library.

When Matplotlib draws a chart, memory leaks there. It requests a canvas (memory for storing information about the shape, about the chart), draws on this canvas, but the allocated memory is not released in any way, and it's not fixed because this is in the library engine itself. That's why you need a separate process to draw the graphic. When the drawing process draws the chart, it just dies, and thus frees all memory allocated to it, including memory for the canvas.

## Menus and Applications

The MIPTGram application has the following main menus and features:

0. **Main Window**: This window is the first window that appears when you launch the application. It displays an animation along with the application logo.
<img src="https://sun9-10.userapi.com/impg/vxHx4kiCvqC2ZKGmg1JWqOqzRyq6Em9Ny3EVCQ/2yEVshjlru4.jpg?size=886x1920&quality=96&sign=3f611fb6fe4d5cadc88985361a5fe02d&type=album" alt="main window" width="200"/>

1. **Login Window**: This window allows users to either register a new account or log in to an existing one. When the user presses the login button, the application sends a request to the database. If the request is successful, the application retrieves all the user's information, including their schedule and new posts. On subsequent visits, the application will not display this information again since it will be saved on the user's device.
<img src="https://sun9-73.userapi.com/impg/F5FVLAU7exII14EDnTtm8cFjh-iK0kpAMoRAYg/O1h7PU1B_pI.jpg?size=886x1920&quality=96&sign=de55bda8b59077d52fe35f7ffe965b3d&type=album" alt="login window" width="200"/>

2. **Schedule Window**: This window displays the user's schedule with all their subjects. Users can swipe left or right to switch between days of the week, add a new subject to their schedule, or delete a subject. Any changes made to the schedule will update the database.
<img src="https://sun9-58.userapi.com/impg/4JqiU1bKkKpCtVgXdHBJFyOBRjNzK71ZKqSEKg/inF8CVF-1FE.jpg?size=886x1920&quality=96&sign=790c4e206fb6b29e2cd272c9a73645d8&type=album" alt="schedule window" width="200"/>

3. **Side Menu**: The side menu allows users to switch to any of the other windows, view their personal information, or log out of their account.
<img src="https://sun9-48.userapi.com/impg/6AAvy4pep-gWgiXSKTW84SW6Z9FykO95I2pL4g/3w7xz6ZcPtU.jpg?size=886x1920&quality=96&sign=ef90f93b2907cb1d1eb54c175037dfed&type=album" alt="side menu" width="200"/>

4. **Phystech.Confessions Window**: This window displays posts that are visible to all users. Users can add a new post, which updates the database and allows other users to read it.
<img src="https://sun9-69.userapi.com/impg/AMAti5Yz-ipBMAq893fmx_O2YxDSSsWt_dL8MQ/IrKSzAQ2Teo.jpg?size=886x1920&quality=96&sign=59aa9dd4979c111fefa4aad0c9156508&type=album" alt="confessions window" width="200"/>

5. **MiptChat** This window contains the chat, which will be further developed. You can click on the dialog with another user and go to a separate window with correspondence, or you can swipe to the right to go to the menu of online calls.

 | <img src="https://sun9-28.userapi.com/impg/_FjlWveQzZIw_airx_n7Js4AadpyvptzIyODNw/RUBRFpywUmk.jpg?size=886x1920&quality=96&sign=2f85b12cdb5f256f98ff363ee61c270b&type=album" alt="miptchat" width="200"/> 
 | <img src="https://sun9-33.userapi.com/impg/k7Y65SbvlxaIWab0PwSU_Zwkmd8kMjY3Ysl16g/pRO1wtmoGYA.jpg?size=886x1920&quality=96&sign=08f137efa5d5b7523348b21361982804&type=album" alt="dialog" width="200"/>
 | <img src="https://sun9-72.userapi.com/impg/c916GXOGQCeUXqzGlYS8sPvrg6SA0QqujJMOAA/UKEA6yfX_8M.jpg?size=886x1920&quality=96&sign=41722443c61e6e0a96545ce68e49f963&type=album" alt="calls" width="200"/>
 |

6. **Graph Builder Window**: In this window, users can enter data, which the application sends to the server for processing using the method of least squares. The error is also calculated, and the output is a graph of the data that users can use to design their lab work.

<img src="https://sun9-9.userapi.com/impg/LyB83cKRrg8xQEgpfIFA8-YyIKGU1mIFZTyzsw/N4zet6udtR4.jpg?size=804x606&quality=96&sign=f2139840c2be57c009c18e54615ddb57&type=album" alt="graph" width="400"/>

## Installation
For installiation download latest version [here](https://github.com/vorontsov-amd/Miptgram/tags)

* For Android:
  + Download miptgram.apk.tar.gz to your Android-based smartphone from latest version on "Releases" button in this repository.
  + Extract and install miptgram.apk from this archieve.
  + Use with pleasure!
  
* For Linux:
  + Download linux-app.tar.gz to your Linux-based device from latest version on "Releases" button in this repository.
  + Extract "release" folder from this archieve
  + Go to this folder:
  ```
  cd release/bundle
  chmod +x Miptgram
  ```
  + Launch the application by double-click on Miptgram in /release/bundle or write this command in /release/bundle:
  ```
  ./Miptgram
  ```
  + Use with pleasure!

To install and run the MIPTgram project from github repository, follow these steps:
1. Clone the repository: `git clone https://github.com/vorontsov-amd/Miptgram.git`
2. Install the Flutter SDK: follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).
3. Install PostgreSQL: follow the instructions on the [PostgreSQL website](https://www.postgresql.org/download/).
4. Update dependency `flutter pub get`
6. Run the client: `flutter run`

## License
The MIPTgram project is licensed under the MIT License. You can find a copy of the license in the `LICENSE` file in the project repository. The MIT License is a permissive free software license that allows for reuse within proprietary software as well as free and open-source software. It allows for modification, distribution, and private use of the software as long as the original copyright and license notices are retained.

## Future Plans

In the future, the MIPTGram team plans to add a chat room to the application so that users can communicate with each other. They also plan to improve the user interface and add more features to the application, such as notifications and the ability to share posts.

