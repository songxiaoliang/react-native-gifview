import React, {Component} from 'react';
import {
  requireNativeComponent
} from 'react-native';

let RCTGIFImageView = requireNativeComponent('GIFImageView', RCTGIFView);
class RCTGIFView extends Component {
  
  render() {
    return <RCTGIFImageView  {...this.props}/>
  }
}

module.exports = RCTGIFView;