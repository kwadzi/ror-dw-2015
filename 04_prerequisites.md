---
layout: page
title: "Requirements"
permalink: /prereq/
icon: <i class="fa fa-check-square-o"></i>
---

In order to fully enjoy the content of this course, you should have a bit of experience in programming and web technologies. In addition, you must be sure that your laptop and your development environment match the technical requirements listed below __BEFORE__ the beginning of the course. 

We won't be able to give live support for the installation and configurarion of any software on your laptop. You must arrive **ready**.

# What do you need to **know** for participating to this course? 

Well, there is a lot of people out there that say RoR is easy to learn and to use, but the honest truth is that it is *NOT* that easy and simple, as you will come to know in this course. That's why we expect you to have a bit of experience in software development and web programming. 

In particular we expect you to know a bit of 

* Linux Command Line
* git
* HTML, JS and CSS.
* Object Oriented Programming

You should also have an account on [Github](http://github.com), it will come in handy.

# What do you need to **have** for participating to this course?

Rails is easy to install on your machine, if you know how to do it.

For this course we expect you to have a fully operational RoR environment on your computer.

## Technical Requirements

If you work on a __ Mac__, please visit [this page](https://gorails.com/setup/osx/10.9-mavericks) and carefully follow the steps. You can skip the MySql and PostGreSQL sections.

If you work on <i class="fa fa-linux"></i> __Ubuntu__ (or another Linux Distro), please visit [this page](https://gorails.com/setup/ubuntu/14.04) and carefully follow the steps. Choose `rbenv` to install Ruby and skip the MySql and PostGreSQL sections.

Finally, if you work on <i class="fa fa-windows"></i> __MS Windows™__, you have two options:

* install [Ubuntu 14.04.1 LTS](http://www.ubuntu.com/download/desktop/contribute/?version=14.04.1&architecture=amd64) on another partition and follow the instructions above.
* install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and follow the instructions below.

## Using Ubuntu on a VirtualBox on MS Windows™ on your PC

After having installed [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and the Extenstion Pack, download [this Ubuntu 14.04.1 LTS Virtual Machine][vm_download] (approx 2.1GB) we created specifically for the workshop.

Once the download is finished double click on the file, Select "_Reinitialize the MAC address for all the cards_" and it will automatically add a VM called "_RoR-SA-14.04.1_" to your VirtualBox. 

Start it and login with the following credentials (if needed):

* username: `ror-student`
* password: `rubyonrails`

Once you are in, open a Terminal (Ctrl+Alt+T) and [setup your Github account](https://gorails.com/setup/ubuntu/14.04#git).

Now you have a fully operational RoR environment on your computer! Cool.

[vm_download]: http://ict4g.org/ror-ec-2014-files/RoR-SA-14.04.1.ova