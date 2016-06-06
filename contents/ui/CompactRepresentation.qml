/*
 * Copyright (C) 2016 Anselmo L. S. Melo <anselmolsm@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.calendar 2.0 as PlasmaCalendar
import ApplicationLauncher 1.0

Application {
  id: launch  
  appName: PlasmaCalendar.Calendar.calendarBackend;
}
Timer {
	interval: 500
	running: true;
	repeat: true;
	onTriggered: label.text = label.prefix+calendarBackend.currentWeek(); 
}

PlasmaComponents.Label {
  id: label
  text: ""
  
  property string prefix: plasmoid.configuration.customPrefix

  PlasmaCalendar.Calendar {
    id: calendarBackend
  }
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter

  function currentWeek() {
    // Sunday & First 4-day week == ISO-8601, which is followed by Qt
    var week = calendarBackend.currentWeek()

    if (plasmoid.configuration.firstWeekOfYearIndex == 1) {
      // Check if January 1st is after Wednesday.
      var date = new Date(calendarBackend.year, 1, 1);
      var firstJanDayofWeek = date.getDay();
      // Wednesday == 3, week starting on Sunday
      if (firstJanDayofWeek > 3)
        week = week + 1;
    }
    return week < 10 ? "0" + week : week
  }

  Layout.minimumWidth : 50
}
