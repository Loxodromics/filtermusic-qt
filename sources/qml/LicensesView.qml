import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/sources/javascript/UiConstants.js" as UI

Rectangle {
    id: root

    color: "white"

    onVisibleChanged: {
        if (visible) {
            GTracker.sendScreenView("LicensesView")
        }
    }

    MouseArea {
        id: closeButton

        anchors.right: parent.right
        anchors.top: parent.top
        width: Math.max(closeText.height, closeText.width) + UI.PADDING_SMALL
        height: width

        Rectangle {
            id: backgroundRect

            anchors.fill: parent
            radius: width / 2
            color: "white"
            border.color: "gray"
            border.width: 1
        }

        Text {
            id: closeText
            text: "x"
            anchors.centerIn: parent
        }

        onClicked: {
            root.visible = !root.visible
        }
    }

    ScrollView {
        id: licensesScrollView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top:closeButton.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 1
        anchors.leftMargin: UI.PADDING_TINY
        anchors.rightMargin: 0
        anchors.bottomMargin: 1

        Text {
            id: privaryViewText
            focus: true

            wrapMode: Text.WordWrap
            font.family: UI.FONT_NAME
            font.pointSize: UI.TEXT_SIZE_NORMAL

            text:"
<h1 style='text-align: center'>This app uses this software / libraries under the following licenses</h1>
<br><hr><br>
<p class='p1'>The source code to this app is available here: https://github.com/Loxodromics/filtermusic-qt</p>
<br><hr><br>
<p class='p1'>Qt is available under the GNU Lesser General Public License version 3.</p>
<p class='p1'>The Qt Toolkit is Copyright (C) 2016 The Qt Company Ltd. and other contributors.<br>
Contact: http://www.qt.io/licensing/</p>
<p class='p1'>Reference:</p>
<p class='p1'><span class='Apple-tab-span'>	</span><span class='Apple-tab-span'>	</span>GNU Lesser General Public License, version 3</p>
<p class='p1'>LGPL version 3</p>
<p class='p1'><span>                   </span>GNU LESSER GENERAL PUBLIC LICENSE</p>
<p class='p1'><span>                       </span>Version 3, 29 June 2007</p>
<p class='p2'><br></p>
<p class='p1'><span> </span>Copyright (C) 2007 Free Software Foundation, Inc. &lt;http://fsf.org/&gt;</p>
<p class='p1'><span> </span>Everyone is permitted to copy and distribute verbatim copies</p>
<p class='p1'><span> </span>of this license document, but changing it is not allowed.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>This version of the GNU Lesser General Public License incorporates</p>
<p class='p1'>the terms and conditions of version 3 of the GNU General Public</p>
<p class='p1'>License, supplemented by the additional permissions listed below.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>0. Additional Definitions.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>As used herein, 'this License' refers to version 3 of the GNU Lesser</p>
<p class='p1'>General Public License, and the 'GNU GPL' refers to version 3 of the GNU</p>
<p class='p1'>General Public License.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>'The Library' refers to a covered work governed by this License,</p>
<p class='p1'>other than an Application or a Combined Work as defined below.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>An 'Application' is any work that makes use of an interface provided</p>
<p class='p1'>by the Library, but which is not otherwise based on the Library.</p>
<p class='p1'>Defining a subclass of a class defined by the Library is deemed a mode</p>
<p class='p1'>of using an interface provided by the Library.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>A 'Combined Work' is a work produced by combining or linking an</p>
<p class='p1'>Application with the Library.<span>  </span>The particular version of the Library</p>
<p class='p1'>with which the Combined Work was made is also called the 'Linked</p>
<p class='p1'>Version'.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>The 'Minimal Corresponding Source' for a Combined Work means the</p>
<p class='p1'>Corresponding Source for the Combined Work, excluding any source code</p>
<p class='p1'>for portions of the Combined Work that, considered in isolation, are</p>
<p class='p1'>based on the Application, and not on the Linked Version.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>The 'Corresponding Application Code' for a Combined Work means the</p>
<p class='p1'>object code and/or source code for the Application, including any data</p>
<p class='p1'>and utility programs needed for reproducing the Combined Work from the</p>
<p class='p1'>Application, but excluding the System Libraries of the Combined Work.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>1. Exception to Section 3 of the GNU GPL.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>You may convey a covered work under sections 3 and 4 of this License</p>
<p class='p1'>without being bound by section 3 of the GNU GPL.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>2. Conveying Modified Versions.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>If you modify a copy of the Library, and, in your modifications, a</p>
<p class='p1'>facility refers to a function or data to be supplied by an Application</p>
<p class='p1'>that uses the facility (other than as an argument passed when the</p>
<p class='p1'>facility is invoked), then you may convey a copy of the modified</p>
<p class='p1'>version:</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>a) under this License, provided that you make a good faith effort to</p>
<p class='p1'><span>   </span>ensure that, in the event an Application does not supply the</p>
<p class='p1'><span>   </span>function or data, the facility still operates, and performs</p>
<p class='p1'><span>   </span>whatever part of its purpose remains meaningful, or</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>b) under the GNU GPL, with none of the additional permissions of</p>
<p class='p1'><span>   </span>this License applicable to that copy.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>3. Object Code Incorporating Material from Library Header Files.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>The object code form of an Application may incorporate material from</p>
<p class='p1'>a header file that is part of the Library.<span>  </span>You may convey such object</p>
<p class='p1'>code under terms of your choice, provided that, if the incorporated</p>
<p class='p1'>material is not limited to numerical parameters, data structure</p>
<p class='p1'>layouts and accessors, or small macros, inline functions and templates</p>
<p class='p1'>(ten or fewer lines in length), you do both of the following:</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>a) Give prominent notice with each copy of the object code that the</p>
<p class='p1'><span>   </span>Library is used in it and that the Library and its use are</p>
<p class='p1'><span>   </span>covered by this License.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>b) Accompany the object code with a copy of the GNU GPL and this license</p>
<p class='p1'><span>   </span>document.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>4. Combined Works.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>You may convey a Combined Work under terms of your choice that,</p>
<p class='p1'>taken together, effectively do not restrict modification of the</p>
<p class='p1'>portions of the Library contained in the Combined Work and reverse</p>
<p class='p1'>engineering for debugging such modifications, if you also do each of</p>
<p class='p1'>the following:</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>a) Give prominent notice with each copy of the Combined Work that</p>
<p class='p1'><span>   </span>the Library is used in it and that the Library and its use are</p>
<p class='p1'><span>   </span>covered by this License.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>b) Accompany the Combined Work with a copy of the GNU GPL and this license</p>
<p class='p1'><span>   </span>document.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>c) For a Combined Work that displays copyright notices during</p>
<p class='p1'><span>   </span>execution, include the copyright notice for the Library among</p>
<p class='p1'><span>   </span>these notices, as well as a reference directing the user to the</p>
<p class='p1'><span>   </span>copies of the GNU GPL and this license document.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>d) Do one of the following:</p>
<p class='p2'><br></p>
<p class='p1'><span>       </span>0) Convey the Minimal Corresponding Source under the terms of this</p>
<p class='p1'><span>       </span>License, and the Corresponding Application Code in a form</p>
<p class='p1'><span>       </span>suitable for, and under terms that permit, the user to</p>
<p class='p1'><span>       </span>recombine or relink the Application with a modified version of</p>
<p class='p1'><span>       </span>the Linked Version to produce a modified Combined Work, in the</p>
<p class='p1'><span>       </span>manner specified by section 6 of the GNU GPL for conveying</p>
<p class='p1'><span>       </span>Corresponding Source.</p>
<p class='p2'><br></p>
<p class='p1'><span>       </span>1) Use a suitable shared library mechanism for linking with the</p>
<p class='p1'><span>       </span>Library.<span>  </span>A suitable mechanism is one that (a) uses at run time</p>
<p class='p1'><span>       </span>a copy of the Library already present on the user's computer</p>
<p class='p1'><span>       </span>system, and (b) will operate properly with a modified version</p>
<p class='p1'><span>       </span>of the Library that is interface-compatible with the Linked</p>
<p class='p1'><span>       </span>Version.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>e) Provide Installation Information, but only if you would otherwise</p>
<p class='p1'><span>   </span>be required to provide such information under section 6 of the</p>
<p class='p1'><span>   </span>GNU GPL, and only to the extent that such information is</p>
<p class='p1'><span>   </span>necessary to install and execute a modified version of the</p>
<p class='p1'><span>   </span>Combined Work produced by recombining or relinking the</p>
<p class='p1'><span>   </span>Application with a modified version of the Linked Version. (If</p>
<p class='p1'><span>   </span>you use option 4d0, the Installation Information must accompany</p>
<p class='p1'><span>   </span>the Minimal Corresponding Source and Corresponding Application</p>
<p class='p1'><span>   </span>Code. If you use option 4d1, you must provide the Installation</p>
<p class='p1'><span>   </span>Information in the manner specified by section 6 of the GNU GPL</p>
<p class='p1'><span>   </span>for conveying Corresponding Source.)</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>5. Combined Libraries.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>You may place library facilities that are a work based on the</p>
<p class='p1'>Library side by side in a single library together with other library</p>
<p class='p1'>facilities that are not Applications and are not covered by this</p>
<p class='p1'>License, and convey such a combined library under terms of your</p>
<p class='p1'>choice, if you do both of the following:</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>a) Accompany the combined library with a copy of the same work based</p>
<p class='p1'><span>   </span>on the Library, uncombined with any other library facilities,</p>
<p class='p1'><span>   </span>conveyed under the terms of this License.</p>
<p class='p2'><br></p>
<p class='p1'><span>   </span>b) Give prominent notice with the combined library that part of it</p>
<p class='p1'><span>   </span>is a work based on the Library, and explaining where to find the</p>
<p class='p1'><span>   </span>accompanying uncombined form of the same work.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>6. Revised Versions of the GNU Lesser General Public License.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>The Free Software Foundation may publish revised and/or new versions</p>
<p class='p1'>of the GNU Lesser General Public License from time to time. Such new</p>
<p class='p1'>versions will be similar in spirit to the present version, but may</p>
<p class='p1'>differ in detail to address new problems or concerns.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>Each version is given a distinguishing version number. If the</p>
<p class='p1'>Library as you received it specifies that a certain numbered version</p>
<p class='p1'>of the GNU Lesser General Public License 'or any later version'</p>
<p class='p1'>applies to it, you have the option of following the terms and</p>
<p class='p1'>conditions either of that published version or of any later version</p>
<p class='p1'>published by the Free Software Foundation. If the Library as you</p>
<p class='p1'>received it does not specify a version number of the GNU Lesser</p>
<p class='p1'>General Public License, you may choose any version of the GNU Lesser</p>
<p class='p1'>General Public License ever published by the Free Software Foundation.</p>
<p class='p2'><br></p>
<p class='p1'><span>  </span>If the Library as you received it specifies that a proxy can decide</p>
<p class='p1'>whether future versions of the GNU Lesser General Public License shall</p>
<p class='p1'>apply, that proxy's public statement of acceptance of any version is</p>
<p class='p1'>permanent authorization for you to choose that version for the</p>
<p class='p1'>Library.</p>

<br><br><hr><br>
<div>Music Icon made by <a href='https://www.flaticon.com/authors/smashicons' title='Smashicons'>Smashicons</a> from <a href='https://www.flaticon.com/' title='Flaticon'>www.flaticon.com</a> is licensed by <a href='http://creativecommons.org/licenses/by/3.0/' title='Creative Commons BY 3.0' target='_blank'>CC 3.0 BY</a></div>

"
            width: licensesScrollView.viewport.width - UI.PADDING_TINY

            MouseArea {
                id: hideMouseArea

                anchors.fill: parent

                onClicked: {
                    root.visible = !root.visible
                }
            }
        }
    }

}
